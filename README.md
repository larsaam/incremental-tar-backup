incremental-tar-backup
=======================

Bash script for incremental backups


Configuration/Implementation
=============================

Replace in the scripts the references to:

* <code>DIR</code>: the directory we want to backup
* <code>/path/to/dir</code>: the path to the directory CONTAINING <code>DIR</code>
* <code>/path/to/workspace</code>: the path to a directory that we use temporarily to host the tar/snar
* <code>/backup</code>: a directory where the backups are located, probably a storage server mounted in a local directory
* <code>DATE</code>: a variable that I declare to reference the date and use it in file names (no need to change it)

First run the script [full-back-up.sh](https://github.com/CGastrell/incremental-tar-backup/blob/master/full-back-up.sh) by hand to initialize the files incremental and snapshot.


typical use
==========

These scripts are mainly used to save states of a directory incrementally.
In other words, we can build these scripts to make a backup of a site that we have
published without having to copy all the files, only the ones that have changed.
Example of reference variables:

* <code>DIR</code>: /var/www/mysite
* <code>/path/to/dir</code>: /var/www
* <code>/path/to/workspace</code>: /var/backups/website
* <code>/backup</code>: /mount/backupserverNFS


crontab
=======

For these scripts to make sense, they must be put in the [cron](https://en.wikipedia.org/wiki/Cron).

You have to be careful that the account that generates the crontab has read/write permissions on the directories
corresponding.

Then, we do not want to run the full backup very often, in my case it is every 10 days at 3AM (or, as they say, every time the
day of the month is a multiple of 10). Ex:

<pre>
0 3 */10 * * /path/to/full-backup.sh
</pre>

And for the incremental to run every day at 4AM:

<pre>
0 4 * * * /path/to/incremental-backup.sh
</pre>

It is important that you run the [full-back-up.sh](https://github.com/CGastrell/incremental-tar-backup/blob/master/full-back-up.sh) by hand the first time (not wait for the cron to do it).


Simple incremental vs incremental by levels
==============================================

The [tar](http://kb.iu.edu/data/acfi.html) incremental can be used in 2 ways:

* Creating direct incrementals on a full back up (simple)
* Creating incremental levels (less simple)

In the first case, an incremental is done using the <code>--listed-incremental</code> parameter and a file of
snapshot (.snar) that is responsible for comparing and defining the differences to include in the incremental. To restore
<code>DIR</code> it will suffice to extract the full backup and then the date to be restored.

<pre>
tar -xzpf DIR-20130720-full.tar.gz
tar -xzpf DIR-20130724-incremental.tar.gz
</pre>

In the second, the incremental is always done over another incremental. While this form gives more control over
the incremental and the file size, when you want to restore <code>DIR</code> it will have to be done sequentially
How are incrementals made? Example considering that we have 4 incrementals:

<pre>
tar -xzpf DIR-20130720-full.tar.gz
tar -xzpf DIR-20130721-incremental.tar.gz
tar -xzpf DIR-20130722-incremental.tar.gz
tar -xzpf DIR-20130723-incremental.tar.gz
tar -xzpf DIR-20130724-incremental.tar.gz
</pre>
