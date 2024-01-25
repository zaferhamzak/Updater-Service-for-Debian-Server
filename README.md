## Güncelleme Servisi (TechWaves)

Bu proje, Linux tabanlı sistemlerde düzenli olarak sistem güncellemeleri uygulamak için bir güncelleme servisi içerir. Aşağıda projenin temel özellikleri ve kullanımı hakkında bilgi bulabilirsiniz.
# Özellikler

    Esnek Güncelleme Yolu: Kullanıcı, güncelleme dosyalarını depolamak için özel bir yol belirleyebilir.
    Güvenli Güncellemeler: Güncelleme dosyaları ve servis, güvenlik önlemleri ile birlikte çalışır.
    Güncelleme İyileştirmeleri: Sistemdeki güncellemeleri kontrol eder, yedekleme yapar ve kullanıcıdan onay alarak güncelleme işlemini gerçekleştirir.
## Kullanım

# Depoyu Klonlayın:

    git clone https://github.com/zaferhamzak/Updater-Service-for-Debian-Server
    cd Updater-Service-for-Debian-Server
    sudo bash update-service.sh
    
 # Servisi Başlatın:
 
    sudo systemctl enable update.timer
    sudo systemctl start update.timer
