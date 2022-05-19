module main

import os
import szip
import v.util.version

const (
	version = '0.0.1'
	author = 'Christopher Fore'
	license = 'GPLv3'
	v_version = version.full_v_version(true)
)

fn main() {
	if '-h' in os.args || '--help' in os.args  {
		println('Usage: vbk [options] <in> <out>')
		println('-i, --interactive	Walks you through zip creation (Will ignore <in> and <out>)')
		println('-v, --version		Prints the VBK and V versions')
	} else if '-i' in os.args || '--interactive' in os.args {
		interactive()
	} else if '-V' in os.args || '--version' in os.args {
		println('VBK Version:	$version')
		println('V Version:	$v_version')
	} else {
		arg_len := os.args.len
		// Fetching the input and output from the arguments
		mut input := os.args[arg_len - 2]
		mut output := os.args[arg_len - 1]

		// Some shells do this automatically, doing this just for compatibility
 		output = os.expand_tilde_to_home(output) 
		input = os.expand_tilde_to_home(input)
		
		if '-v' in os.args || '--verbose' in os.args {
			backup(input, output, true)
		} else {
			backup(input, output, false)
		}
	}
}

fn backup(cp string, dst string, is_verbose bool) {
	mut files := []string{}
	mut pfiles := &files
	
	if is_verbose {
		os.walk(cp, fn [mut pfiles] (f string) {
			pfiles << f
			println('Found: $f')
		})
	} else {
		os.walk(cp, fn [mut pfiles] (f string) {
			pfiles << f
		})
	}


	szip.zip_files(files, dst) or {
		return
	}

	println('Successfully backed up!')
}