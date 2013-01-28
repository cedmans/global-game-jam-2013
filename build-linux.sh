#!/bin/bash

zip -r ./${PWD##*/}.love *
cat /usr/bin/love "./global-game-jam-2013.love" > ./heart-healer-extreme && rm "./global-game-jam-2013.love" && chmod +x ./heart-healer-extreme

