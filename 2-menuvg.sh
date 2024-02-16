#!/bin/bash

# Fungsi untuk menampilkan menu
show_menu() {
    echo -e "\e[32mManagemen Volume Group (VG)\e[0m"
    #echo "Pembuatan Volume Group (VG)"
    echo "------------------------------"
    echo "1. Tampilkan semua physical volumes (PV)"
    echo "2. Buat VG baru"
    echo "3. Tampilkan semua VG"
    #echo "4. Refresh semua VG"
    echo "4. Keluar/kembali ke menu utama"
}

# Fungsi untuk menampilkan semua physical volumes (PV)
show_physical_volumes() {
    pvs
}

# Fungsi untuk membuat VG baru
create_new_vg() {
    read -p "Masukkan nama VG baru: " vg_name
    read -p "Masukkan nama physical volume (PV) yang ingin ditambahkan (pisahkan dengan spasi untuk PV lebih dari satu) mis : /dev/sdb : " pv_names
    vgcreate "$vg_name" "$pv_names"
}

# Fungsi untuk menampilkan semua VG
show_all_vg() {
    vgs
}

# Fungsi untuk merefresh semua VG
#refresh_all_vg() {
#    vgchange -ay
#}

# Loop utama untuk menampilkan menu
while true; do
    show_menu
    read -p "Pilih menu (1-4): " choice
    case $choice in
        1)
            show_physical_volumes
            ;;
        2)
            create_new_vg
            ;;
        3)
            show_all_vg
            ;;
        #4)
        #    refresh_all_vg
        #    ;;
        4)
            echo "==============================================="
            exit
            ;;
        *)
            echo "Pilihan tidak valid. Silakan pilih lagi."
            ;;
    esac
done
