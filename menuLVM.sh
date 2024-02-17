#!/bin/bash

# Fungsi untuk menampilkan menu
show_menu() {
    echo -e "\e[31m####### === LOGICAL VOLUME MANAGER (LVM) === ########\e[0m"
    #echo "Pilih menu LOGICAL VOLUME MANAGER (LVM):"
    echo "1. Menu PV"
    echo "2. Menu VG"
    echo "3. Menu LV"
    echo "4. Keluar"
}

# Fungsi untuk menampilkan menu PV
call_menu_pv() {
    while true; do
        ./1-menupv.sh
        read -p "Tekan Enter untuk kembali ke menu utama atau 'q' untuk keluar: " input
        if [ "$input" == "q" ]; then
            exit
        elif [ -z "$input" ]; then
            break
        fi
    done
}

# Fungsi untuk menampilkan menu VG
call_menu_vg() {
    while true; do
        ./2-menuvg.sh
        read -p "Tekan Enter untuk kembali ke menu utama atau 'q' untuk keluar: " input
        if [ "$input" == "q" ]; then
            exit
        elif [ -z "$input" ]; then
            break
        fi
    done
}

# Fungsi untuk menampilkan menu LV
call_menu_lv() {
    while true; do
        ./3-menulv.sh
        read -p "Tekan Enter untuk kembali ke menu utama atau 'q' untuk keluar: " input
        if [ "$input" == "q" ]; then
            exit
        elif [ -z "$input" ]; then
            break
        fi
    done
}

# Loop utama untuk menampilkan menu
while true; do
    show_menu
    read -p "Pilih menu (1-4): " choice
    case $choice in
        1)
            call_menu_pv
            ;;
        2)
            call_menu_vg
            ;;
        3)
            call_menu_lv
            ;;
        4)
            echo "Terima kasih telah menggunakan skrip ini. Sampai jumpa!"
            exit
            ;;
        *)
            echo "Pilihan tidak valid. Silakan pilih lagi."
            ;;
    esac
done

