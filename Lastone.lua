-- Research Script: Runtime Stability (ARM64)
-- Target: libc.so (exit, abort, ptrace)

function patch_libc_stability()
    print("Memulai proses patching libc.so...")
    
    -- 1. Cari range libc.so
    local ranges = gg.getRangesList('libc.so')
    local libc_base = nil
    
    for i, v in ipairs(ranges) do
        if v.state == 'Xa' then -- Cari bagian executable
            libc_base = v.start
            break
        end
    end

    if libc_base == nil then
        print("Gagal menemukan libc.so!")
        return
    end

    -- 2. Daftar fungsi yang akan di-patch ke RET (C0 03 5F D6)
    -- Catatan: Offset bisa berubah tiap versi Android, 
    -- disarankan menggunakan gg.getSymbols jika tersedia.
    local targets = {
        {name = "exit",  patch = "C0 03 5F D6"}, 
        {name = "abort", patch = "C0 03 5F D6"},
        -- ptrace: MOV W0, #0 (00 00 80 52) + RET (C0 03 5F D6)
        {name = "ptrace", patch = "00 00 80 52 C0 03 5F D6"} 
    }

    local symbols = gg.getSymbols('libc.so')
    
    for _, target in ipairs(targets) do
        local found = false
        for _, sym in ipairs(symbols) do
            if sym.name == target.name then
                gg.setValues({{
                    address = sym.address,
                    flags = gg.TYPE_DWORD, -- Pakai DWORD untuk Hex
                    value = target.patch:gsub(" ", ""),
                }})
                print("Patched: " .. target.name .. " at " .. string.format("%X", sym.address))
                found = true
                break
            end
        end
        if not found then print("Symbol tidak ditemukan: " .. target.name) end
    end
    
    gg.toast("Patching Selesai! Aplikasi lebih stabil.")
end

patch_libc_stability()
