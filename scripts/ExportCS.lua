require("Scripts.CommonFunctions")

function getCurrentDirectory()
  stdout = io.popen("cd")
  local output = stdout:read('*all')
  stdout:close()
  return output
end

-- file: fileHandle
-- al: AddressList
-- i: index
function skipChildren(file, al, i)
  local count = al[i].Count
  for c=1, count do
    i = i + 1
    if al[i].Type == vtString and al[i].String.Size == 0 then
      i = skipChildren(file, al, i)
    end
  end
  return i
end

local al=getAddressList()
local mbinStructName = al[0].getDescription()

printf("EXPORTING CS: " .. mbinStructName .. ".cs ...")

local currentDir = getCurrentDirectory()
printf("Current Directory = %s", currentDir)

local file = io.open(mbinStructName .. ".cs", "w")
file:write("namespace MBINCompiler.Models.Structs\n")
file:write("{\n")
file:write("    public class " .. mbinStructName .. " : NMSTemplate\n")
file:write("    {\n")
local i = 0
while i < al.Count-1 do
  i = i + 1
  local desc = al[i].Description
  local addr = al[i].Address
  local type = al[i].Type
  local name = desc
  if string.sub(name, 1, 1) == "[" then -- trim "[+XXXX] "
    name = string.sub(name, 9, -1)
  end
  if string.sub(name, 1, 1) == "?" then -- trim "? "
    name = string.sub(name, 3, -1)
  end
  local f = string.find(name, " ")
  if f ~= nil then -- trim everything after and including the space
    name = string.sub(name, 1, f-1)
  end
  name = name:sub(1,1):upper()..name:sub(2) -- capitalize first character
  addr = string.format("%04s", string.sub(addr, 2, -1))
  local error = false
  local csType = "float"
  if type == vtByte then
    csType = "byte"
    local dropDownList = al[i].DropDownList.Text
    if dropDownList ~= "" then
      if dropDownList:sub(1, 7) == "0:false" then
        csType = "bool"
      end
      while dropDownList:sub(-2, -1) == "\r\n" do -- rtrim \r\n
        dropDownList = dropDownList:sub(0, -3)
      end
      -- replace "\r\n" with ", "
      dropDownList = dropDownList:gsub("\r\n", ", ")
      desc = desc .. " (" .. dropDownList .. ")"
    end
  elseif type == vtDword then
    csType = "int"
    if name == "Unknown" then
      name = name .. "Int"
    end
    local dropDownList = al[i].DropDownList.Text
    if dropDownList ~= "" then
      while dropDownList:sub(-2, -1) == "\r\n" do -- rtrim \r\n
        dropDownList = dropDownList:sub(0, -3)
      end
      -- replace "\r\n" with ", "
      dropDownList = dropDownList:gsub("\r\n", " ")
      desc = desc .. " (" .. dropDownList .. ")"
    end
  elseif type == vtSingle then
    csType = "float"
  elseif type == vtString then
    if al[i].String.Size == 0 then -- struct
      csType = name
      name = "Unknown"
      i = skipChildren(file, al, i)
    else -- string field
      file:write(string.format("        %38s [NMS(Size = 0x%02X)]\n", "", al[i].String.Size))
      csType = "string"
    end
  elseif type == vtByteArray then
    csType = "byte[]"
    local ignore = ""
    if name == "Reserved" then
      name = "Padding"
      ignore = ", Ignore = true"
    end
    file:write(string.format("        %38s [NMS(Size = 0x%02X%s)]\n", "", al[i].Aob.Size, ignore))
  else
    error = true
  end
  if error == false then
    file:write(string.format("        /* %-32s */ ", desc))
    if desc:len() > 32 then
      file:write(string.format("\n           %-32s    ", ""))
    end
    file:write("public " .. csType .. " " .. name .. addr .. ";\n")
  else
    printf("error " .. addr)
  end
end
file:write("    }\n")
file:write("}\n")
file:close()

printf("... FINISHED")
