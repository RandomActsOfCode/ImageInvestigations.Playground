#!/usr/bin/env python3
# Run all tests from a swift package

def sandbox_root():
    """
    Return sandbox's root path
    """
    import pathlib
    root = pathlib.Path(__file__).parent.resolve() # Sandbox/Tools
    return root.parent.resolve()                   # Sandbox

def get_package_name():
    """
    Get the name of a package from the package manifest
    :returns: The name of the package
    """
    import re

    # TODO: Better error handling
    with open(sandbox_root() / 'Package.swift', 'r') as f:
        line = [line for line in f if 'name:' in line][0]
        return re.search('name:[\t ]+"(.+)"', line).group(1)

def run_all_tests():
    """
    Run all tests defined in the Swift package manifest
    :returns: Exit code of 0 on success, or 1 if any failures are encountered
    """
    from subprocess import run, DEVNULL, STDOUT
    from os.path import relpath

    returncode = 0
    package_name= get_package_name()
    command = ['xcodebuild', 'test',
               '-scheme', f'{package_name}-Package',
               '-destination', 'platform=iOS Simulator,name=iPhone 8']

    print("Running all package tests")
    process = run(command, cwd=sandbox_root(), encoding="utf8")

    return process.returncode

def main():
    returncode = run_all_tests()
    exit(returncode)

if __name__== "__main__" :
    main()
