#!/bin/sh

(
    echo a
    echo b
)
(
    echo a
    echo b
) | cat
if echo a > /dev/null; then
    (
        echo if-t-a
        echo if-t-b
    )
else
    (
        echo if-f-a
        echo if-f-b
    )
fi
{
    echo a
    echo b
}
{
    echo a
    echo b
} | cat
if echo a > /dev/null; then
    {
        echo if-t-a
        echo if-t-b
    }
else
    {
        echo if-f-a
        echo if-f-b
    }
fi
