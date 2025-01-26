{ pkgs, ... }: {

  systemd.services.church-prores-conversion = {
    description = "Convert iPad footage to ProRes proxy for Resolve";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScriptBin "convert-to-prores" ''
      #!/usr/bin/env bash
        set -e

        # Directories
        SOURCE_DIR="/mnt/storage-ssd/editing-workspace/GCC/h265"
        DEST_DIR="/mnt/storage-ssd/editing-workspace/GCC/prores"

        # Ensure the destination directory exists
        mkdir -p "$DEST_DIR"

        # Find and process H.264 and H.265 files
        find "$SOURCE_DIR" -type f \\( -iname \"*.mp4\" -o -iname \"*.mkv\" \\) | while read -r file; do
            # Extract file name without extension
            base_name=$(basename "$file" | sed 's/\\.[^.]*$//')

            # Destination file path
            dest_file="$DEST_DIR/$base_name.mov"

            # Skip conversion if the ProRes file already exists
            if [[ -f "$dest_file" ]]; then
                echo "ProRes file already exists for: $file"
                continue
            fi

            # Convert to ProRes Proxy quality
            echo "Converting $file to ProRes Proxy..."
            ${pkgs.ffmpeg}/bin/ffmpeg -i "$file" -c:v prores -profile:v 0 -c:a copy "$dest_file"

            # Check for success
            if [[ $? -eq 0 ]]; then
                echo "Conversion completed: $dest_file"
            else
                echo "Conversion failed for: $file"
            fi
        done
      ''}";
      };
    };

    systemd.timers.church-prores-conversion = {
      description = "Run conversion script hourly";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "hourly";
        Persistent = true;
      };
    };
}
