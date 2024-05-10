## Network Utility Script

**Description:**

This versatile script offers various functionalities related to network information, hostname management, and potentially additional features in the future (like proxy configuration).

**Current Status:**

This project is currently under development (**Beta** stage). Some functionalities are implemented, while others are planned for future versions.

**Installation (if applicable):**

1. Save the script as `main.sh`.
2. Open a terminal and navigate to the directory where you saved the script.
3. Make the script executable using the following command:

   ```bash
   chmod +x main.sh
   ```

4. (Optional) If you want to run the script from anywhere in your terminal, you can add the script's directory to your PATH environment variable. Refer to your system's documentation for details.

**Usage:**

1. Run the script with root privileges using `sudo`:

   ```bash
   sudo ./main.sh
   ```

2. The script will display a menu with available options.
3. Select the desired option using the corresponding number and press Enter.

**Features (implemented):**

- **IP Status:**
    - Shows current IP information (if using Tor, displays the Tor IP).
    - Fetches additional details like geolocation, ISP, and organization (when available) using external APIs.

- **MAC Address:**
    - Provides options to:
        - Change the MAC address of your network interface (wlan0) for temporary spoofing. **Use with caution!** Spoofing can disrupt network connectivity and may be against your network's terms of service.
        - Restore the original MAC address.
        - View the current MAC address.

- **Hostname:**
    - Allows you to:
        - Change your system's hostname (temporary change). **Be aware of potential network issues!** Changing your hostname could affect how other devices recognize your system.
        - Restore the original hostname.
        - View the current hostname.

**Planned Features:**

- **Proxy Configuration:**
    - Functionality to configure proxy settings (Tor, i2p) is planned for future development.

**Important Notes:**

- **Root Privileges:** The script requires root privileges for certain functionalities like changing the MAC address or hostname.
- **Caution:** Changing the MAC address or hostname can have network-related consequences. Use these features responsibly and understand their potential impacts.
- **Customization:** Feel free to customize the script's behavior or add features based on your specific needs. Refer to the script's code for details.


