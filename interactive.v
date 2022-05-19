module main

import os

fn interactive() {
	// User interaction
	mut output := os.input('Where do you wish to save your backups? (ex. /home/user/back.zip)\nPath: ')

	mut copy_dir := os.input('Specify the directory you would like to backup.\nPath: ')

	// This is done so I don't have to do this later on, will add checks later
	output = os.expand_tilde_to_home(output) 

	copy_dir = os.expand_tilde_to_home(copy_dir)

	// Checking if the output directories exist
	if os.exists(os.dir(output))  {
		ask_verbose := os.input('Would you like for it to be verbose? (y/n) ')

		if ask_verbose.to_lower() == 'y' {
			backup(copy_dir, output, true)
		} else if ask_verbose.to_lower() == 'n' {
			backup(copy_dir, output, false)
		} else {
			eprintln('Invalid input')
			return
		}

	} else {
		dir_check_fail := os.input('The directory you specified does not exist, would you like to create it?\nAnswer (y or n): ')
		
		match dir_check_fail {
			'y' {
				println('Creating directories now...')
				
				os.mkdir_all(os.dir(output)) or {
					eprintln('Encountered an error')
					return
				}

				backup(copy_dir, output, false)
			}
			'n' {
				println('Exiting...')
				return
			}
			else {
				eprintln('Unexpected input...')
				return
			}
		}
	}
}