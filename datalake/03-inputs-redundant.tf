# This file and the following variables was added to stop a series of warnings being shown during plan and apply
# because the environment config files contain variables for multiple terraform modules.
#
# Blocks are defined for the unused (and therefore redundant) variables a provide defaults so that if they aren't
# provided at any point the module won't throw errors.
