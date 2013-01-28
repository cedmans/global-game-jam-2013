#!/bin/bash -ex

NAME="heart-healer-extreme"

rm -r heart-healer-extreme.app
zip -r ../${PWD##*/}.love *
cp -r /Applications/love.app/ $NAME.app
mv ../global-game-jam-2013.love $NAME.app/Contents/Resources/

PLIST="$NAME.app/Contents/Info.plist"
perl -pi -e 's/org.love2d.love/org.calpoly.hhe/' $PLIST
perl -pi -e 's/LÖVE/Heart Healer Extreme/' $PLIST

