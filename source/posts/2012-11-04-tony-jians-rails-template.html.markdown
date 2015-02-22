---
title: My Rails Template
date: 2012-11-04 16:24 +0800
comments: true
tags: Ruby on Rails, Ruby
category: 程式
draft: true
---

## Why

We engineers always hate repeating doing the same thing.

Take me for instance, everytime I create a new rails project, I edit `GemFile` to install lots of useful gems such as `devise`, `carrierwave`, etc, and then download [Twitter Bootstrap](http://twitter.github.com/bootstrap/) with newest version, extract it into `vendor/assets/images`, `vendor/assets/javascripts` and `vendor/assets/stylesheets`, finally, replace `../img/xxx.png` into `xxx.png` in `bootstrap.css` and `bootstrap.min.css`.

## What

My template does two things:

1.  Automatically install the following gems:

    *   devise
    *   cancan
    *   carrierwave
    *   simple_form
    *   dynamic_form
    *   will_paginate
    *   rdiscount
    *   rails-i18n

2.  Download Twitter Boostrap with the newest version, and correspondingly extract files into `vendor/assets/`

## Usage

    rails new myapp -m=https://raw.github.com/gist/4010690

Alternatively, if you encounter some SSL problem during the previous command, please download the file directly and run:

    rails new myapp -m=filename

<!-- more -->

## Source Code

{% gist 4010690 %}