#!/bin/bash

# Fungsi untuk menampilkan menu
show_menu() {
    echo -e "\e[32mManajemen Logical Volume (LV)\e[0m"
    echo "-------------------------------------------"
    echo "1. Menampilkan semua Volume Group (VG)"
    echo "2. Membuat LV baru, mounting, dan input fstab"
    echo "3. Menampilkan semua LV"
    echo "4. Memperluas/extend LV"
    echo "5. Keluar/kembali ke menu utama"
}

# Fungsi untuk menampilkan semua Volume Group (VG)
show_all_vg() {
    vgs
}

# Fungsi untuk membuat LV baru, mounting, dan input fstab
create_new_lv_and_mount() {

    # Membaca nama VG dari pengguna
    read -p "Masukkan nama Volume Group (VG) yang akan digunakan: " vg_name

    # Memeriksa apakah VG yang dimasukkan ada
    if ! vgs "$vg_name" &> /dev/null; then
        echo "Volume Group (VG) tidak ditemukan. Kembali ke menu utama."
        return
    fi

    # Membaca nama LV dari pengguna
    read -p "Masukkan nama LV baru: " lv_name

    # Memeriksa apakah LV dengan nama yang sama sudah ada dalam VG yang dipilih
    if lvs "/dev/$vg_name/$lv_name" &> /dev/null; then
        echo "Logical Volume (LV) dengan nama yang sama sudah ada dalam Volume Group (VG) yang dipilih. Kembali ke menu utama."
        return
    fi

    # Membaca ukuran LV dari pengguna
    read -p "Masukkan ukuran LV (misal: 1G, 100M, dll): " lv_size

    # Meminta pengguna memilih jenis sistem file
    echo "Pilih jenis sistem file untuk LV baru:"
    echo "1. ext4"
    echo "2. xfs"
    read -p "Pilih jenis sistem file (1/2): " fs_type_choice

    case $fs_type_choice in
        1)
            fs_type="ext4"
            ;;
        2)
            fs_type="xfs"
            ;;
        *)
            echo "Jenis sistem file tidak valid. Menggunakan ext4 sebagai default."
            fs_type="ext4"
            ;;
    esac

    lvcreate -L "$lv_size" -n "$lv_name" "$vg_name"

    # Membuat mount point
    read -p "Masukkan lokasi mount point (contoh: /mnt/mydata): " mount_point
    mkdir -p "$mount_point"

    # Format LV dengan jenis sistem file yang dipilih
    if [ "$fs_type" == "ext4" ]; then
        mkfs.ext4 "/dev/$vg_name/$lv_name"
    elif [ "$fs_type" == "xfs" ]; then
        mkfs.xfs "/dev/$vg_name/$lv_name"
    else
        echo "Jenis sistem file tidak valid. LV tidak diformat."
        return 1
    fi

    # Mount LV
    mount "/dev/$vg_name/$lv_name" "$mount_point"

    # Input ke file sistem fstab
    echo "/dev/mapper/$vg_name-$lv_name    $mount_point    $fs_type    defaults    0 0" | sudo tee -a /etc/fstab
}

# Fungsi untuk menampilkan semua LV
show_all_lv() {
    lvs
}

# Fungsi untuk memperluas LV
extend_lv() {
    read -p "Masukkan nama LV yang akan diperluas: " lv_name
    read -p "Masukkan ukuran tambahan untuk LV (misal: 1G, 100M, dll): " lv_extra_size

    lvextend -L +$lv_extra_size "/dev/$vg_name/$lv_name"

    # Menghapus karakter ekstra `/` sebelum menggunakan xfs_growfs
    lv_path="/dev/${vg_name}/${lv_name}"
    lv_path_cleaned="${lv_path//\/\//\/}"

    # Memperluas sistem file
    if [[ "$(lsblk -no FSTYPE ${lv_path_cleaned})" == "xfs" ]]; then
        xfs_growfs "${lv_path_cleaned}"
    else
        resize2fs "${lv_path_cleaned}"
    fi
}

# Loop utama untuk menampilkan menu
while true; do
    show_menu
    read -p "Pilih menu (1-5): " choice
    case $choice in
        1)
            show_all_vg
            ;;
        2)
            create_new_lv_and_mount
            ;;
        3)
            show_all_lv
            ;;
        4)
            extend_lv
            ;;
        5)
            echo "==============================================="
            exit
            ;;
        *)
            echo "Pilihan tidak valid. Silakan pilih lagi."
            ;;
    esac
done
