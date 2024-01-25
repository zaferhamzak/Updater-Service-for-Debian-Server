User
#!/bin/bash

# Güncelleme dosyasını daha esnek hale getirin.
default_update_path="/etc/.techwaves/updates"
log_file="/var/log/update_script.log"
# Güncelleme dosyasını daha güvenilir hale getirin.
if [ -z "$1" ]; then
  path="$default_update_path"
else
  path="$1"
fi

# Güncelleme dosyası oluştur
if [ ! -d "$path" ]; then
  mkdir -p "$path"
fi

if echo "#!/bin/bash" > "$path/.update.sh"; then
  # Güncelleme dosyasına komutları ekle
  echo "sudo apt update" >> "$path/.update.sh"
  echo "sudo apt upgrade -y" >> "$path/.update.sh"
  echo "sudo apt dist-upgrade -y" >> "$path/.update.sh"
else
  echo "Hata: Güncelleme dosyası oluşturulamadı."
  exit 1
fi

# Güncelleme dosyasını daha işlevsel hale getirin.

# check_updates fonksiyonunu ekle
function check_updates() {
  # Güncellemeleri kontrol et
  sudo apt update

  # Güncelleme olup olmadığını kontrol et
  if [ "$?" -eq 0 ]; then
    echo "Güncellemeler mevcut"
    echo "Güncellemelerin boyutu: $(du -sh /var/cache/apt/archives | cut -f1)"
    echo "Güncellemelerin sayısı: $(apt list --upgradable | wc -l)"
    if [ -f /home/user/backups/apt-updates.backup ]; then
      echo "Yedekleme başarılı"
    else
      echo "Yedekleme başarısız"
    fi

    read -p "Güncellemeleri gerçekleştirmek istediğinizden emin misiniz? (E/H): " confirm
    if [[ "$confirm" =~ ^[EeYy]$ ]]; then
      sudo apt upgrade -y
      echo "$(date '+%Y-%m-%d %H:%M:%S'): Güncelleme işlemi tamamlandı." >> "$log_file"
    else
      echo "Güncelleme işlemi iptal edildi"
      echo "Güncelleme yok"
    fi
  else
    echo "Güncelleme yok"
  fi
}

# Servis dosyası oluştur
if echo "[Unit]" > "/etc/systemd/system/update.service"; then
  echo "Description=Güncelleme Servisi(TechWawes)" >> "/etc/systemd/system/update.service"
  echo "After=network.target" >> "/etc/systemd/system/update.service"
  echo "[Timer]" >> "/etc/systemd/system/update.service"
  echo "OnCalendar=*:0/6" >> "/etc/systemd/system/update.service"
  echo "Persistent=true" >> "/etc/systemd/system/update.service"
  echo "[Service]" >> "/etc/systemd/system/update.service"
  echo "Type=simple" >> "/etc/systemd/system/update.service"
  echo "ExecStart=/bin/bash $path/.update.sh" >> "/etc/systemd/system/update.service"
  echo "Restart=on-failure" >> "/etc/systemd/system/update.service"
  echo "[Install]" >> "/etc/systemd/system/update.service"
  echo "WantedBy=timers.target" >> "/etc/systemd/system/update.service"  
else
  echo "Hata: Servis dosyası oluşturulamadı."
  exit 1
fi

# Servisi başlat
systemctl enable update.service
systemctl start update.service
