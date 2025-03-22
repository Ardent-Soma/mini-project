#!/bin/bash

echo "Running pre-commit syntax check..."

# Find all staged shell (.sh) and Python (.py) scripts
FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(sh|py)$')

# Flag to track if any script fails
EXIT_STATUS=0

# Loop through each staged script
for FILE in $FILES; do
    if [ -f "$FILE" ]; then
        case "$FILE" in
            *.sh)
                echo "Checking shell script syntax for $FILE..."
                bash -n "$FILE"
                if [ $? -ne 0 ]; then
                    echo "Syntax error in $FILE. Commit aborted!"
                    EXIT_STATUS=1
                fi
                ;;
            *.py)
                echo "Checking Python script syntax for $FILE..."
                python3 -m py_compile "$FILE"
                if [ $? -ne 0 ]; then
                    echo "Syntax error in $FILE. Commit aborted!"
                    EXIT_STATUS=1
                fi
                ;;
        esac
    fi
done

if [ $EXIT_STATUS -ne 0 ]; then
    exit 1
fi

echo "All scripts passed syntax check!"
exit 0

