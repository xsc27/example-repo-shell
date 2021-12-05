PATH="${PWD}/dist:${PATH}"

@test "invoking script with one argument" {
    run prog.sh foo
    [ "$output" = "Hello foo!" ]
}

@test "invoking script with two arguments" {
    run prog.sh foo bar
    [ "$output" = "Hello foo bar!" ]
}

@test "invoking script without arguments" {
    run prog.sh
    [ "$output" = "Hello World!" ]
}
