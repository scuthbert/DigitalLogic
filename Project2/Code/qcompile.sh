#/bin/bash
/opt/altera/quartus/bin/quartus_map --read_settings_files=on --write_settings_files=off Project2
/opt/altera/quartus/bin/quartus_fit --read_settings_files=on --write_settings_files=off Project2
/opt/altera/quartus/bin/quartus_asm --read_settings_files=on --write_settings_files=off Project2
/opt/altera/quartus/bin/quartus_sta Project2
/opt/altera/quartus/bin/quartus_eda --read_settings_files=on --write_settings_files=off Project2
