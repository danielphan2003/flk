rec {
  mkPersist = option: type: file: persistFile: "${type} ${file} ${option} ${persistFile}";
  mkCustomPersist = user: group: mkPersist "- ${user} ${group} -" "L";
  bwPersist = bwPath: persistPath: file: mkCustomPersist "bitwarden_rs" "bitwarden_rs" "${bwPath}/${file}" "${persistPath}${bwPath}/${file}";
}
