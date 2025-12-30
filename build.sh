#!/usr/bin/env bash
set -e

if [ -z "$GAME_LIBS" ]; then
    echo "Usage: GAME_LIBS=/path/to/Exocolonist_Data/Managed ./build.sh"
    exit 1
fi

dotnet build -c Release -p:GameLibs="$GAME_LIBS"
echo "Built: bin/Release/net472/HolopalmPlus.dll"
