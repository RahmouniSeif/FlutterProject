import re
import fileinput
import sys
import os
import subprocess
import time
import shutil

compt = 0

# Define the substitutions to make
substitutions = [
    (r"\`1\[", r"."),
    (r"Result\]", r"Result"),
    (r"Item\]", r"Item")
]

# Load the input file
# --- CRITICAL FIX: Changed to raw string (r"...") ---
with open(r"C:\Users\MAC14\Desktop\cross plat\FlutterProject\campify.json", "r") as f: 
    input_text = f.read()

print('Done')

# Apply the substitutions
print('2) =====<<< Applying Changes on File "YesBS.json" >>>=====')
print('Progress : 0%')

for old, new in substitutions:
    input_text = re.sub(old, new, input_text)
    compt += 25
    print('Progress : ' + str(compt) + '%')

compt = 100
print('Progress : ' + str(compt) + '%')

# --- CRITICAL FIX: Changed to raw string (r"...") ---
with open(r"C:\Users\MAC14\Desktop\cross plat\FlutterProject\campify.json", "w") as f:
    f.write(input_text)

print('Done')

# Generate openApi
print('\n3) =====<<< Generate openApi please wait ... >>>=====')

# --- CRITICAL FIX: Changed to raw string (r"...") ---
default_path = r'C:\Users\MAC14\Desktop\cross plat\FlutterProject' 
# --- CRITICAL FIX: Changed to raw string (r"...") ---
command = r'java -jar openapi-generator-cli.jar generate -i "C:\Users\MAC14\Desktop\cross plat\FlutterProject\campify.json" -g dart -o "C:\Users\MAC14\Desktop\cross plat\FlutterProject\GeneratedServices"'

# Using f-string for powershell command, ensure variables are correct
process = subprocess.Popen(['powershell.exe', '-NoExit', f'cd "{default_path}"; {command}']) 

time.sleep(30)
print('Done')


# Specify the source and destination directories
# --- CRITICAL FIX: Changed to raw string (r"...") ---
source_dir = r'C:\Users\MAC14\Desktop\cross plat\FlutterProject\GeneratedServices\lib' 
# --- CRITICAL FIX: Changed to raw string (r"...") ---
destination_dir = r'C:\Users\MAC14\Desktop\cross plat\FlutterProject\campify\lib\GeneratedServices' 

if not os.path.exists(source_dir):
    print("Source directory does not exist.")
    exit(1)

if not os.path.exists(destination_dir):
    os.makedirs(destination_dir)

for item in os.listdir(source_dir):
    source_item_path = os.path.join(source_dir, item)
    destination_item_path = os.path.join(destination_dir, item)
    
    if os.path.exists(destination_item_path):
        if os.path.isfile(destination_item_path):
            os.remove(destination_item_path)
        elif os.path.isdir(destination_item_path):
            shutil.rmtree(destination_item_path)
            
    shutil.move(source_item_path, destination_dir)
    
print('Done')


# Specify the folder path to be deleted
# --- CRITICAL FIX: Changed to raw string (r"...") ---
folder_path = r'C:\Users\MAC14\Desktop\cross plat\FlutterProject\GeneratedServices' 

shutil.rmtree(folder_path)
print('Done')

print("\n \n ====<< ALL PROCESSES ARE WORKING SMOOTHLY! YOU CAN CONTINUE WITH YOUR WORK. GOOD LUCK! ^_^ >>====")
