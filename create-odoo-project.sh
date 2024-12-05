#!/bin/bash

Help()
{
   echo "Creates Odoo dev environment with standardized structure."
   echo
   echo "Syntax: create-odoo-project [-|n|v|m|h]"
   echo "options:"
   echo "   n     Project name - required (e.g. xyz-company)"
   echo "   v     Odoo version to use (default=16.0)"
   echo "   m     Technical name of custom module to scaffold (e.g. hr_custom)"
   echo "   h     Print this Help."
   echo
}


while getopts n:v:m:h option; do
   case $option in
        h)
            Help
            exit;;
        n)
            project_name=${OPTARG};;
        v)
            odoo_version=${OPTARG};;
        m)
            module_name=${OPTARG};;
        \?) # Invalid option
            echo "Error: Invalid option"
            exit;;
   esac
done


if [$project_name == ""] ;then
    echo "Error: Project name not provided"
    exit 1
fi

mkdir $project_name
cd $project_name

printf "\nCreating python virtual environment in ./.env ...\n"
python -m venv .env

mkdir src local bin filestore logs

if [$odoo_version == ""] ;then
    odoo_version=16.0
fi

echo
echo "Cloning Odoo ${odoo_version}"
echo
git clone -b $odoo_version --single-branch --depth 1 https://github.com/odoo/odoo.git src/odoo
# ln -s ~/workspace/odoo/odoo-repo-cache/16.0/odoo src

echo
echo "Inastalling depndencies from src/odoo/requirements.txt"
echo
.env/bin/pip3 install -r src/odoo/requirements.txt

echo "#!/bin/sh
ROOT=\$(dirname \$0)/..
PYTHON=\$ROOT/.env/bin/python3
ODOO=\$ROOT/src/odoo/odoo-bin
\$PYTHON \$ODOO -c \$ROOT/${project_name}.cfg \"\$@\" && exit \$?" >> bin/odoo

chmod 744 bin/odoo


if [ $module_name != "" ] ;then
    .env/bin/python3 src/odoo/odoo-bin scaffold $module_name local
else
    mkdir -p local/dummy
    touch local/dummy/__init__.py
    echo '{"name": "dummy", "installable": False}' > local/summy/__manifest__.py
fi

bin/odoo --stop-after-init --save --addons-path src/odoo/odoo/addons,src/odoo/addons,local --data-dir filestore

echo '.*
!.gitignore
*.py[co]
*.cfg
/.env/
/src/
/filestore/
/logs/' >> .gitignore


git init
git add .
git commit -m "Initial version"

echo
echo "Project setup succesfully. Edit ${project_name}.cfg to set db, port, log and other options."
echo "Then cd ${project_name} && bin/odoo !"
echo
