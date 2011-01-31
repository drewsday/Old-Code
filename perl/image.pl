#!/usr/bin/perl
    
use Image::Magick;

    $image = Image::Magick->new;
    $image->Set(size=>'100x100');
    $image->ReadImage('xc:white');
    $image->Set('pixel[49,49]'=>'red');

$image->Write('test.gif');


