#!/usr/bin/perl -wpi

BEGIN
{
    my @parts = localtime();
    $year = $parts[5] += 1900;
}

s/\(C\)\s+(\d+)(-\d+)?/(C) $1-$year/;
