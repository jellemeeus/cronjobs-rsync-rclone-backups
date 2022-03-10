# cronjobs-rsync-rclone-backups
Easy automated backups to local and remote drives with cronjobs, rsync and rclone

We can specify which files to upload with filters (`*.txt`) and easily upload to multiple cloud drives with variable data cap limits

In the end crontab will look like this with easy expansion of drives and selection of files to backup

Selection of `crontab -l`
```
...
CRONJOBS=/home/user/scripts/cronjobs
# Local daily and weekly backups
18 18 * * * export DRIVE=Speed; export FREQUENCY=daily;"$CRONJOBS"/rsync.sh
35 18 * * FRI export DRIVE=Speed; export FREQUENCY=weekly;"$CRONJOBS"/rsync.sh
# Copy to Mega user2@mail.com (50GB limit)
40 18 * * * export DRIVE=mega_usr2; export FILES=all;"$CRONJOBS"/rclone.sh
# Copy to Onedrive user@mail.com (5GB limit)
40 18 * * * export DRIVE=onedrive_jdotm; export FILES=critical;"$CRONJOBS"/rclone.sh
...
```

These jobs will periodically run `rclone` like this
```
(simplified) rclone copy --filter-from $FILTER $HOME $DRIVE:Ubuntu
```
and run `rsync` like this
```
(simplified) rsync -r --delete -f 'merge '${FILTER} /home/user/ /media/user/${DRIVE}/backups/${FREQUENCY}
```
with a filter `$FILTER` specifying exclude/include files
e.g `filter_{FILES}.txt`
```
+ /Pictures/**
- /Documents/NotImportant/**
+ /Documents/**
- *
```

## Requirements

* Crontab (tested on Ubuntu 20.04)
* rsync
* [Rclone](https://rclone.org/)

## Setup

- [ ] create local (rsync) directories 

- [ ] setup remote (rclone) accounts

- [ ] create filters

- [ ] Create a log directory in `~/.local/log` 

- [ ] put `*.sh` scripts and `*.txt` filters in `~/scripts/cronjobs` 

- [ ] edit `crontab -e` 

### rsync
For instance directory structure can look like this
```
/media/user/{Drive}/backups/{daily}
/media/user/{SomeOtherDrive}/backups/{weekly}
```
We will call `rsync.sh` and fill in these Drive and Frequency in crontab later 

`export DRIVE=Drive; export FREQUENCY=daily;"$CRONJOBS"/rsync.sh`

### [Rclone](https://rclone.org/)

Install Rclone https://rclone.org/install/

Setup remote account(s), my preference https://mega.nz/

Step through Configuration with `rclone config` specific to type of Storage. See docs for specific instructions https://rclone.org/docs/

We can call `rsync.sh` and fill in Drive and Files (filter) 

`export DRIVE=user_mega; export FILES=critical;"$CRONJOBS"/rclone.sh`

### What to backup? Defining filters
Filters for rclone `filter_critical.txt` defined as `filter_{FILES}.txt`
```
+ /.bashrc
+ /.bash_aliases
+ /.vimrc
+ /.ssh/config
+ /scripts/**
- /Veracrypt/personal.veracrypt
- /Veracrypt/temp.veracrypt
+ /Veracrypt/**
+ /Pictures/avatars/**
+ /Documents/jub/**
+ /Documents/Text/**
+ /Documents/Thesis/**
- *
```
I use `critical`, `normal` and `all` as level, with each progressing in size. 

`filter_rsync.txt` is the same as `filter_all.txt` with `**` replaced to `***`
```
+ /.bashrc
+ /.bash_aliases
+ /.vimrc
+ /.ssh/config
+ /scripts/**
- /Veracrypt/temp.veracrypt
+ /Veracrypt/**
+ /Pictures/**
+ /Documents/**
- *
```

## Put filters and scripts in their locations

Put `*.sh` scripts and filters `*.txt` in `~/scripts/cronjobs` 

structure will look like
```
.
├── filter_all.txt
├── filter_critical.txt
├── filter_normal.txt
├── filter_rsync.txt
├── rclone.sh
└── rsync.sh
```

## Log

Logs are created in `~/.local/log`

## Crontab -e
edit `crontab -e`

For local specify `DRIVE` and `FREQUENCY` as `/media/user/{Drive}/backups/{daily}`

For remote specify `DRIVE` and `FILES` as `{DRIVE}:Ubuntu` and `filter_{FILES}.txt`

```
CRONJOBS=/home/user/scripts/cronjobs
# Local 
18 18 * * * export DRIVE=Speed; export FREQUENCY=daily;"$CRONJOBS"/rsync.sh
# Copy to Mega user2@mail.com (50GB limit)
40 18 * * * export DRIVE=mega_usr2; export FILES=all;"$CRONJOBS"/rclone.sh
...
```

## Test
Export `DRIVE FREQUENCY FILES` like `export DRIVE=drive`

edit `*.sh` to add `--dry-run` to the command

run `./rclone.sh` and check logs in `~/.local/log`
