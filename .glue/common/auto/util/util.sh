# shellcheck shell=bash

# Get the absolute path of the absolute working directory of
# the current project. Do not specify function with '()' because
# we assume consumer invokes function in subshell to capture output
util.get_working_dir() {
	while [ ! -f "glue.sh" ] && [ "$PWD" != / ]; do
		cd ..
	done

	if [ "$PWD" = / ]; then
		die 'No glue config file found in current or parent paths'
	fi

	printf "%s\n" "$PWD"
}

# Get any particular file, parameterized by any
# top level folder contained within "$GLUE_WD/.glue"
util.get_file() {
	local dir="$1"
	local file="$2"

	REPLY=
	if [ -f "$GLUE_WD/.glue/$dir/$file" ]; then
		REPLY="$GLUE_WD/.glue/$dir/$file"
	elif [ -f "$GLUE_WD/.glue/$dir/auto/$file" ]; then
		REPLY="$GLUE_WD/.glue/$dir/auto/$file"
	else
		error.file_not_found_in_glue_store "$file" "$dir"
	fi
}

# Get any particular file in the 'actions' directory
# Pass '-q' as the first arg to set the result to
# '$REPLY' rather than outputing to standard output
util.get_action() {
	if [ "$1" = "-q" ]; then
		util.get_file "actions" "$2"
	else
		util.get_file "actions" "$1"
		printf "%s\n" "$REPLY"
	fi
}

# Get any particular file in the 'commands' directory
# Pass '-q' as the first arg to set the result to
# '$REPLY' rather than outputing to standard output
util.get_command() {
	if [ "$1" = "-q" ]; then
		util.get_file "commands" "$2"
	else
		util.get_file "commands" "$1"
		printf "%s\n" "$REPLY"
	fi
}

# Get any particular file in the 'configs' directory
# Pass '-q' as the first arg to set the result to
# '$REPLY' rather than outputing to standard output
util.get_config() {
	if [ "$1" = "-q" ]; then
		util.get_file "configs" "$2"
	else
		util.get_file "configs" "$1"
		printf "%s\n" "$REPLY"
	fi
}

util.ln_config() {
	if [ -f "$GLUE_WD/.glue/configs/$1" ]; then
		ln -sfT ".glue/configs/$1" "$GLUE_WD/$1"
	elif [ -f "$GLUE_WD/.glue/configs/auto/$1" ]; then
		ln -sfT ".glue/configs/auto/$1" "$GLUE_WD/$1"
	else
		error.file_not_found_in_glue_store "$1" 'configs'
	fi
}
