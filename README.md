# Create Odoo Project

### Description
This is a shell script that will automatically setup a heavily opinionated Odoo project
structure.

Downloading the script is enough to "install" but for more convenience, we can copy it to
anywhere in `$PATH`.
``` shell
git clone https://github.com/abrehamm/create-odoo-project.git
cp create-odoo-project/create-odoo-project.sh /usr/bin/create-odoo-project
```

### Usage
``` shell
$ create-odoo-project -h
Creates Odoo dev environment with standardized structure.

Syntax: create-odoo-project [-|n|v|m|h]
options:
   n     Project name - required (e.g. xyz-company)
   v     Odoo version to use (default=16.0)
   m     Technical name of custom module to scaffold (e.g. hr_custom)
   h     Print this Help.
```

### Project Structure
The script will create a project with the following directory structure:
```
.
├──src/                 contains Odoo itself, as well as various third-party add-ons
│   └── odoo/
├──local/               used to save instance-specific custom add-ons
├──bin/                 various helper executable shell scripts, e.g odoo-bin
│   └── odoo
├──filestore/           Odoo file store
├──logs/                server log files
└──{project-name}.cfg   the Odoo conf file

```
