#!/bin/bash
bin/php/exec.sh "vendor/bin/phpmd $@ text cleancode,codesize,controversial,design,naming,unusedcode"
