-- ==========================================
-- Anti-Crash / Bypass Detector Basic
-- Untuk Riset Security Core Runners
-- ==========================================

gg.alert("Menjalankan Protokol Anti-FC...")

-- 1. Menyembunyikan Game Guardian dari API Deteksi
-- Teknik ini mencoba membekukan fungsi yang biasa dipakai game buat nyari GG
gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
gg.searchNumber("GameGuardian", gg.TYPE_BYTE) -- Cari string GG di memori
local count = gg.getResultCount()

if count > 0 then
    local r = gg.getResults(count)
    for i, v in ipairs(r) do
        v.value = "0" -- Samarkan string GG jadi nol
        v.freeze = true
    end
    gg.addListItems(r)
    print("Berhasil menyamarkan jejak GG di memori.")
end

-- 2. Mematikan Fungsi Exit/Terminate (Mencoba Mencegah FC)
-- Kita targetkan range Code buat nyari instruksi 'exit' sistem
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("exit", gg.TYPE_BYTE) 
-- Catatan: Ini eksperimental, kalo game pake Java 'System.exit' butuh cara lain

-- 3. Tips Tambahan (Tanpa Skrip):
gg.alert("TIPS AGAR TIDAK FC:\n1. Gunakan GG versi 'Reborn' atau 'Hw'.\n2. Gunakan fitur 'Hide GG from game' level 2/3/4 di setting GG.\n3. Pastikan 'Prevent Unload' diatur ke Level 3.")

print("Selesai. Coba masuk ke game sekarang!")
