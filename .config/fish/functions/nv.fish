function nv
  if set -q "NVIM"
    nvr $argv
  else
    nvim $argv
  end
end
