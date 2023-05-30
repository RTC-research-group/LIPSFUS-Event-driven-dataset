Algunos comandos para ejecutar en kelvin2
-----------------------------------------

# Comando de conexión
ssh -X -p 55890 -i ~/.ssh/arios_xps arios@login.kelvin.alces.network

# Solicitar una sesión con 1 core y 8GB de memoria
srun -p k2-hipri -n 1 --mem=8G --pty bash

# Solicitar una sesión con 1 GPU de 3 horas con 8GB de memoria
srun -p k2-gpu --gres=gpu:1 --time=3:00:00 --mem=8G --pty bash

# Mi path al sistema de archivos scratch. Esto es bueno para poner los datasets y los paquetes de anaconda
/mnt/scratch2/users/arios/

# Listar todos los módulos/apps que están instalados en kelvin2
module avail

# Cargar o añadir un módulo para poder usar la app que deseemos
module load <module_name>
module add <module_name>

# Listar los módulos que estén cargados
module list

# Poner el almacenamiento scratch para los paquetes de anaconda
Se trata de definir las variables de entorno 
export CONDA_PKGS_DIRS=/mnt/scratch2/users/arios/conda/pkgs
export CONDA_ENVS_PATH=/mnt/scratch2/users/arios/conda/envs
