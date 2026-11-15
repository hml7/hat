use bufio;
use fmt;
use fs;
use getopt;
use io;
use os;
use types;

def VERSION: str = "dev";

type options = struct {
	number: bool,
	squeeze: bool,
};

type state = struct {
	index: uint,
	prev_blank: bool,
};

fn print_version() void = {
	fmt::printfln("hat {}", VERSION)!;
};

fn print_line(opts: *options, st: *state, line: str) void = {
	const blank = len(line) == 0;
	if (opts.squeeze && blank && st.prev_blank) {
		return;
	};
	st.prev_blank = blank;
	st.index += 1;

	if (opts.number) {
		fmt::printf("{:6}\t", st.index)!;
	};
	fmt::println(line)!;
};

fn cat(opts: *options, st: *state, in: io::handle) void = {
	const scan = bufio::newscanner(in, types::SIZE_MAX);
	defer bufio::finish(&scan);

	for (true) {
		match (bufio::scan_line(&scan)!) {
		case io::EOF =>
			break;
		case let line: const str =>
			print_line(opts, st, line);
		};
	};
};

fn cat_path(opts: *options, st: *state, path: str) void = {
	if (path == "-") {
		cat(opts, st, os::stdin);
		return;
	};
	const file = match (os::open(path)) {
	case let file: io::file =>
		yield file;
	case let err: fs::error =>
		fmt::fatalf("Error opening {}: {}", path, fs::strerror(err));
	};
	defer io::close(file)!;
	cat(opts, st, file);
};

export fn main() void = {
	const cmd = getopt::parse(os::args,
		"A recreational programming project that reimplements cat(1) in Hare",
		('n', "Display line numbers."),
		('s', "Squeeze consecutive empty lines into one."),
		('V', "Print version."),
		"[file...]",
	);
	defer getopt::finish(&cmd);

	let opts = options { ... };
	for (let opt .. cmd.opts) {
		switch (opt.0) {
		case 'n' =>
			opts.number = true;
		case 's' =>
			opts.squeeze = true;
		case 'V' =>
			print_version();
			os::exit(0);
		case =>
			abort();
		};
	};

	let st = state { ... };
	if (len(cmd.args) == 0) {
		cat(&opts, &st, os::stdin);
	} else {
		for (let path .. cmd.args) {
			cat_path(&opts, &st, path);
		};
	};
};
