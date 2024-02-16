#!/bin/bash

# Fungsi untuk menampilkan menu
show_menu() {
    echo -e "\e[32mManajemen Physical Volume (PV)\e[0m"
    #echo "Pembuatan Physical Volume (PV)"
    echo "-------------------------------"
    echo "1. Tampilkan semua disk yang tersedia"
    echo "2. Buat PV baru"
    echo "3. Tampilkan semua PV"
    echo "4. Keluar/kembali ke menu utama"
}

# Fungsi untuk menampilkan semua disk yang tersedia
show_available_disks() {
lsblk

}

# Fungsi untuk membuat PV baru
create_new_pv() {
    read -p "Masukkan nama disk yang ingin digunakan sebagai PV (contoh: /dev/sdb): " disk_name
    pvcreate "$disk_name"
}

# Fungsi untuk menampilkan semua PV
show_all_pv() {
    pvs
}

# Loop utama untuk menampilkan menu
while true; do
    show_menu
    read -p "Pilih menu (1-4): " choice
    case $choice in
        1)
            show_available_disks
            ;;
        2)
            create_new_pv
            ;;
        3)
            show_all_pv
            ;;
        4)
            echo "==============================================="
            exit
            ;;
        *)
            echo "Pilihan tidak valid. Silakan pilih lagi."
            ;;
    esac
done

