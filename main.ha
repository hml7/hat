use fmt;
use os;
use io;
use fs;
use types;
use bufio;
use getopt;
use strings;

fn print_file_line(
	number_all: bool, 
	remove_empty: bool,
	non_printing: bool,
	index: *uint,
	line: str
) void = {
	if (remove_empty) {
		if (strings::compare(strings::trim(line), "") == 0) {
			*index = *index - 1;
			return;
		};
	};

	if (number_all) {
		fmt::printf("{}\t", *index)!;
	};

	fmt::printf("{}\n", line)!;
};


fn handle_file(
	number_all: bool, 
	remove_empty: bool,
	non_printing: bool,
	path: str
) void = {
	const file = match (os::open(path)) {
	case let file: io::file =>
		yield file;
	case let err: fs::error =>
		fmt::fatalf("Error opening {}: {}", path, fs::strerror(err));
	};
	defer io::close(file)!;

	const scan = bufio::newscanner(file, types::SIZE_MAX);
	defer bufio::finish(&scan);

	for (let i = 1u; true; i += 1) {
		const line = match (bufio::scan_line(&scan)!) {
		case io::EOF =>
			break;
		case let line: const str =>
			yield line;
		};
		print_file_line(number_all, remove_empty, non_printing, &i, line);
	};
};

export fn main() void = {
	const cmd = getopt::parse(os::args,
		"A recreational programming project that reeimplements cat(1) in Hare",
		('n', "add numbers to each line"),
		('s', "remove extra empty lines"),
		('v', "show non-printing characters (except for tabs and end of line)"),
		('f', "file", "path to a file whose content you want to display"),
	);
	defer getopt::finish(&cmd);

	let number_all: bool = false;
	let remove_empty: bool = false;
	let non_printing: bool = false;
	let path: str = "";

	for (let opt .. cmd.opts) {
		switch (opt.0) {
		case 'n' =>
			number_all = true;
		case 's' =>
			remove_empty = true;
		case 'v' =>
			non_printing = true;
		case 'f' =>
			path = opt.1;
		case => abort();
		};
	};

	handle_file(number_all, remove_empty, non_printing, path);
};
