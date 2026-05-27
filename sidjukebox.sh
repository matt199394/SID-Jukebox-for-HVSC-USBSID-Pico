#!/bin/bash

show_sid_info() {
    local file="$1"

    echo "================ SID INFO ================="
    sidplayfp --info "$file" 2>/dev/null
    echo "==========================================="
    echo
}

SUBTUNE=1
HVSC="${1:-.}"
TIME_LIMIT=180

# Indicizza una volta sola
mapfile -t FILES < <(
    find "$HVSC" \( -iname "*.sid" -o -iname "*.rsid" \) | sort
)

TOTAL=${#FILES[@]}
INDEX=0

if [ "$TOTAL" -eq 0 ]; then
    echo "Nessun SID trovato."
    exit 1
fi

cleanup() {
    tput cnorm
    stty sane
    kill $PID 2>/dev/null
    clear
}

trap cleanup EXIT INT TERM

tput civis

play_current() {

    FILE="${FILES[$INDEX]}"

    clear

    echo "================================================="
    echo "              SID JUKEBOX + USBSID"
    echo "================================================="
    echo
    echo "[$((INDEX+1))/$TOTAL]"
    echo
    echo "$FILE"
    echo
   
    echo "Subtune attiva: $SUBTUNE"
    sidplayfp --info "$FILE" 2>/dev/null | head -12
    
    echo
    echo "-------------------------------------------------"
    echo "→ / n = next"
    echo "← / p = previous"
    echo "+     = next subtune"
    echo "-     = previous subtune"
    echo "s     = search"
    echo "r     = random"
    echo "q     = quit"
    echo "-------------------------------------------------"

    sidplayfp --usbsid -o${SUBTUNE} -t${TIME_LIMIT} "$FILE" \
    </dev/null >/dev/null 2>&1 &
    

    PID=$!
}

while true; do

    play_current

    while true; do

        read -rsn1 key

        # Frecce
        if [[ $key == $'\x1b' ]]; then
            read -rsn2 key
        fi

        case "$key" in

            "[C"|n)
                SUBTUNE=1
                kill $PID 2>/dev/null
                INDEX=$(( (INDEX + 1) % TOTAL ))
                break
                ;;

            "[D"|p)
                SUBTUNE=1
                kill $PID 2>/dev/null
                INDEX=$(( (INDEX - 1 + TOTAL) % TOTAL ))
                break
                ;;

            +)
                kill $PID 2>/dev/null
                SUBTUNE=$((SUBTUNE + 1))
                break
                ;;
            -)
                kill $PID 2>/dev/null

                if [ "$SUBTUNE" -gt 1 ]; then
                 SUBTUNE=$((SUBTUNE - 1))
                fi

                 break
                ;;

            r)  
                SUBTUNE=1
                kill $PID 2>/dev/null
                INDEX=$(( RANDOM % TOTAL ))
                break
                ;;

            s)  
                SUBTUNE=1
                kill $PID 2>/dev/null

                tput cnorm
                stty sane

                SELECTED=$(
                    printf '%s\n' "${FILES[@]}" | \
                    fzf --height=40% --reverse \
                        --prompt="Search SID > "
                )

                tput civis

                if [ -n "$SELECTED" ]; then
                    for i in "${!FILES[@]}"; do
                        if [ "${FILES[$i]}" = "$SELECTED" ]; then
                            INDEX=$i
                            break
                        fi
                    done
                fi

                break
                ;;

            q)
                exit
                ;;
        esac
    done
done