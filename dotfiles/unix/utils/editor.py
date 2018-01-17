import subprocess

def run(*args, **kwargs):
	cmdArgs = ['code'] + list(args)
	# if kwargs.get('sudo') == True:
		# ignore sudo option, as VSCode will request admin access when tring to save a file
	subprocess.run(cmdArgs)