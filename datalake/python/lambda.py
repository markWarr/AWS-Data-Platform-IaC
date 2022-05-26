# This lambda function takes the movielens dataset, unzips it and saves it to an s3 bucket.
#  uses boto: https://github.com/boto/boto3
# Each execution context provides 512 MB of additional disk space in the /tmp directory.
# The /tmp directory is used to save the zip file and the extracted files.
# Movielens data set ml-1m is 5.9MB.
import boto3
import zipfile
import urllib

def lambda_handler(event, context):
    # Create the connection with the s3 bucket
    s3client = boto3.client('s3')
    databucketname = 'emr-studio-bucket-mt'
        
    url = 'http://files.grouplens.org/datasets/movielens/ml-1m.zip'
    filename = 'movielens.zip'
    tempdir = '/tmp/{}'
    zippath = tempdir.format(filename)

    # Download the movielens file
    urllib.request.urlretrieve(url, zippath)

    #  extract and save files to s3 bucket
    with zipfile.ZipFile(zippath) as myzip:
        listOfFileNames = myzip.namelist()
        # Iterate over the file names
        for fileNamedat in listOfFileNames:
        # Check filename ends with .dat
            if fileNamedat.endswith('.dat'):
                # Extract a single file from zip into the temp directory
                myzip.extract(fileNamedat, '/tmp/')
                # Open the file into a local variable
                extractedfile = open(tempdir.format(fileNamedat), "r")
                #  save movies.dat to s3 bucket
                s3client.upload_file(tempdir.format(fileNamedat), databucketname, "{}/{}".format('moviedata', fileNamedat))
    
    return {
       'message' : "MovieLens data imported successfully to s3 bucket " + databucketname
   }