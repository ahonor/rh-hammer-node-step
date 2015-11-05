#!/usr/bin/env bash

HAMMER_CMD=${RD_CONFIG_HAMMER_CMD:-hammer}

# Parse script arguments
USER=$1
shift
HOST=$1
shift

# If subcommand did not expand, set it to empty string.
[[ ${RD_CONFIG_HAMMER_SUBCMD} == '${option.subcommand}' ]] && RD_CONFIG_HAMMER_SUBCMD=""

#env|grep RD_|sort

#
# Set up SSH to invoke via hammer
#
# Read the key data from environment and save to a temp file.
TMP_SSH_KEYFILE=$(mktemp "${RD_PLUGIN_TMPDIR}/$(basename ${RD_PLUGIN_BASE})-${RD_CONFIG_SSH_USER}-pem.$$.XXXX")
echo "$RD_CONFIG_TMP_SSH_KEYFILE" > $TMP_SSH_KEYFILE
#    Ssh command flags
SSHOPTS="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o LogLevel=quiet"
SSHOPTS="$SSHOPTS -i $TMP_SSH_KEYFILE"
#    Run it.
echo ssh $SSHOPTS ${RD_CONFIG_SSH_USER}@${HOST} \
	pbrun --user root \
       	$HAMMER_CMD \
	-u ${RD_CONFIG_SSH_USER} \
	-p ${RD_CONFIG_HAMMER_PASSWORD} \
	${RD_CONFIG_HAMMER_COMMAND} \
	${RD_CONFIG_HAMMER_SUBCMD} \
	${RD_CONFIG_HAMMER_SUBCMD_ARGS}
ssh_exitcode=$?

#
# Clean up and exit
#
rm $TMP_SSH_KEYFILE
exit $ssh_exitcode
#
# Done.
