CREATE DATABASE CafeDelicious
ON
(NAME=CafeDeliciousDataFiles,
FILENAME='C:\SQLSever\CafeDelicious\CafeDeliciousDataFiles.mdf',
SIZE=10MB,
MAXSIZE=1GB,
FILEGROWTH=10MB),

FILEGROUP Secondary
(NAME=CafeDeliciousSecondaryDataFiles,
FILENAME='C:\SQLSever\CafeDelicious\CafeDeliciousSecondaryDataFiles.ndf',
SIZE=10MB,
MAXSIZE=1GB,
FILEGROWTH=10MB)

LOG ON 
(NAME=CafeDeliciousLogFiles,
FILENAME='C:\SQLSever\CafeDelicious\CafeDeliciousLogFiles.ldf',
SIZE=10MB,
MAXSIZE=1GB,
FILEGROWTH=10MB)

