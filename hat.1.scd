hat(1) "" "hat manual"

# NAME

hat - concatenate files and print on the standard output

# SYNOPSIS

*hat* [-nsv] [_file_...]

# DESCRIPTION

*hat* reads each _file_ in order and writes it to standard output. With no
_file_, or when _file_ is *-*, it reads standard input.

# OPTIONS

*-n*
	Number all output lines.

*-s*
	Squeeze multiple adjacent empty lines into a single empty line.

*-v*
	Display non-printing characters visibly.

# EXIT STATUS

0 on success, nonzero if any file could not be read.

# SEE ALSO

*cat*(1)
