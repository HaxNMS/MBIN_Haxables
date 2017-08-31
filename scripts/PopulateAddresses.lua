-- Populates the table with a block of addresses of float type.
-- All the records added will be relative to the Base Address record.

-- baseAddress: the memory address for the first record in the block
-- offset: usually you will leave this 0. Changing this will only affect the offset in the record description.
-- count: the number of fields to populate
-- type: can be vtByte, vtDword, vtFloat and others. See the CheatEngine wiki for lua scripting for complete list.
-- typeSize: how many bytes should each field be? this should correspond to the type (vtByte = 1, vtDword and vtFloat =4, etc)
-- addOffsetToChildren: if true, the offset will also affect the field address.
function populateAddresses(baseAddress, offset, count, type, typeSize, addOffsetToChildren)
  local al = getAddressList()

  local base = al.createMemoryRecord()
  base.setAddress(baseAddress)
  base.setDescription("Base Address")
  base.Type = vtString
  base.String.Size = 0

  local step = typeSize
  for i=0, count-1 do
    local childOffset = i * step
    local str = string.format("[+%04X] Unknown", i * step + offset)

    local addr = childOffset
    if addOffsetToChildren then addr = addr + offset end
    addr = string.format("+%X", addr)

    local rec = al.createMemoryRecord()
    rec.setAddress(addr)
    rec.setDescription(str)
    rec.Type = type
    rec.appendToEntry(base)
  end
end

-- YOU MUST EDIT THIS LINE BEFORE EXECUTING!
-- See the function above for description of parameters.
populateAddresses("060", 0x0000, 704, vtSingle, 4, false)
