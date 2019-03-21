# Gblockc.pl
to get around the bug with Gblocks -t=c

I don't know if I use it right, but there seems to be bug with Gblocks -t=c.
I have a protein alignment, I translate it to CDS alignment using pal4nal.pl, after using Gblocks with -t=c to remove the gaps, I translated it back to protein alignment, however, it's not consistent with the original protein anymore.

If you want to check my point, I have an example CDS alignment, you can try with it.

Anyway, here I am, writ a perl script to get around that.

                                                            Du Kang 2019-3-22
