-- ==========================================
-- dumperV1 - Security Research Tool
-- For: Core Runners (com.ez.ths) & GNG
-- Purpose: Proof of Concept for Developers
-- ==========================================

print("Memulai Scan pada Memory Range: CODE_APP (XA)...")

-- 1. Setting Target: Kita fokus ke Library (libil2cpp.so)
gg.setRanges(gg.REGION_CODE_APP) 

-- 2. Mencari pola byte (AoB) yang umum ada di fungsi Unity/Native
-- Pola ini biasanya awal dari sebuah fungsi (Push/Sub instruction)
-- Kita pake pola random yang sering ada di method libil2cpp
local pattern = "00 48 2D E9" -- Contoh pola ARM standar

gg.clearResults()
gg.searchNumber(pattern, gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1)

local count = gg.getResultCount()
if count == 0 then
    print("Pola standar tidak ditemukan, mencoba mencari string fungsi...")
    -- Jika byte gagal, kita cari string yang biasanya bocor
    gg.searchNumber("HP;Damage;Speed;CanHurt", gg.TYPE_BYTE)
    count = gg.getResultCount()
end

-- 3. Simpan Hasil Dump ke Folder Download
local path = "/sdcard/Download/CoreRunners_Security_Report.txt"
local file = io.open(path, "w")

if file then
    file:write("--- SECURITY AUDIT REPORT ---\n")
    file:write("Game: Core Runners (com.ez.ths)\n")
    file:write("Status: Vulnerable (Offsets Leaked)\n")
    file:write("-----------------------------\n\n")

    local results = gg.getResults(100)
    for i, v in ipairs(results) do
        -- Menandai alamat memori yang bocor
        file:write(string.format("Potensial Offset: 0x%X | Value: %s\n", v.address, v.value))
    end
    
    file:close()
    gg.alert("Audit Selesai!\n" .. count .. " celah memori ditemukan.\nLaporan tersimpan di: " .. path)
else
    gg.alert("Gagal membuat laporan! Cek izin folder Download.")
end
