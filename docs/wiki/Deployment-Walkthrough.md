# Deploying a New BrightSign Player at <COMPANY_NAME>

This guide outlines the standard operating procedure for configuring and deploying new BrightSign digital signage players at <COMPANY_NAME>. We utilize the `BrightSignAPI` PowerShell module to automate device registration and configuration.

## Prerequisites

Before you begin, ensure you have the following:
1. **Access to the Provisioning Share**: You must have read/write access to `<NETWORK_SHARE_PATH>`.
2. **API Credentials**: You need your `<COMPANY_NAME>` BSN.cloud Client ID and Secret.
3. **Player Details**: The desired player name and its Ethernet/WiFi MAC address(es) printed on the bottom of the device.

---

## How to Obtain a BSN.cloud API Key

If you do not already have your own Client ID and Secret, you must generate one in the BSN.cloud Web UI:
1. Log into your BSN.cloud Control Cloud portal.
2. Navigate to **Admin** > **Device Provisioning**.
3. Under the **API Credentials** section, click **Add Credential**.
4. Give it a descriptive name (e.g., "PowerShell Provisioning API Key").
5. Copy the generated **Client ID** and **Client Secret**. Keep these secure, as the secret will not be displayed again.

---

## Step 1: Load the Module & Connect to BSN.cloud

Open a PowerShell window. Before you can authenticate, you must import the `BrightSignAPI` module into your session.

```powershell
# 1. Import the module
Import-Module "<NETWORK_SHARE_PATH>\BrightSignAPI\src\BrightSignAPI\BrightSignAPI.psd1"

# 2. Authenticate to the portal
Connect-BsnCloud -ClientId "<CLIENT_ID>" -ClientSecret "<CLIENT_SECRET>" -Network "<COMPANY_BSN_NETWORK_NAME>"
```

*Note: If authentication is successful, your session is securely stored in the background.*

---

## Step 2: Provision the Player Configuration

We use a "Golden Template" approach. Instead of manually using BrightAuthor:connected for every new screen, we clone our master template and inject the new player's unique identity.

Run the following command to generate the configuration folder for a single player. Replace the placeholders with your new player's details:

```powershell
New-BsnPlayer -Name "<NEW_PLAYER_NAME>" `
              -SourceFolder "<NETWORK_SHARE_PATH>\Templates\<GOLDEN_TEMPLATE_FOLDER>" `
              -DestinationRoot "<NETWORK_SHARE_PATH>\Deployments\" `
              -MacEthernet "<MAC_ADDRESS>"
```

### (Optional) Network Certificate Authentication (EAP-TLS)
If the player will connect to a secure enterprise network requiring 802.1x EAP-TLS certificate authentication, you must provide the certificates during provisioning.
1. Ensure your `.p12` or `.pfx` certificates are placed in a designated folder, such as `<NETWORK_SHARE_PATH>\Certificates\`.
2. Add the `-CertificatesDirectory` and `-EncryptedCertPass` parameters to your `New-BsnPlayer` command:

```powershell
New-BsnPlayer -Name "<NEW_PLAYER_NAME>" `
              -SourceFolder "<NETWORK_SHARE_PATH>\Templates\<GOLDEN_TEMPLATE_FOLDER>" `
              -DestinationRoot "<NETWORK_SHARE_PATH>\Deployments\" `
              -MacEthernet "<MAC_ADDRESS>" `
              -CertificatesDirectory "<NETWORK_SHARE_PATH>\Certificates\" `
              -EncryptedCertPass "<ENCRYPTED_PASSWORD_HASH>"
```

**What this does:**
- Automatically requests a fresh Registration Token from BSN.cloud.
- Clones the golden template into a new folder named after your player at `<NETWORK_SHARE_PATH>\Deployments\<NEW_PLAYER_NAME>`.
- Safely injects the token, player name, and MAC address into the `setup.json` file.
- Attaches the correct WPA/802.1x enterprise certificates if applicable.

---

## Step 3: Batch Provisioning (Multiple Players)

If you are deploying multiple players (e.g., a new office rollout), you can automate the entire batch using a CSV file.

1. Create a CSV file at `<NETWORK_SHARE_PATH>\Rollout.csv` with the following columns:
   `Name, MacEthernet, Description`
   *(Add `MacWiFi` or `SSID` columns if needed).*

2. Pipe the CSV directly into the provisioning command:

```powershell
Import-Csv "<NETWORK_SHARE_PATH>\Rollout.csv" | New-BsnPlayer -SourceFolder "<NETWORK_SHARE_PATH>\Templates\<GOLDEN_TEMPLATE_FOLDER>" -DestinationRoot "<NETWORK_SHARE_PATH>\Deployments\" -OutResultFile "<NETWORK_SHARE_PATH>\Deployments\Results.csv"
```

**Why use `-OutResultFile`?**
This will automatically generate a highly detailed `Results.csv` log containing the provisioned paths, auto-generated registration tokens, expiration dates, and MAC addresses for your records.

---

## Step 4: Finalizing the Deployment

1. **Prepare the SD Card:** Insert a blank, FAT32 or exFAT formatted MicroSD card into your computer.  
   > [!WARNING]  
   > **Do NOT use NTFS formatting.** BrightSign players will silently fail to read NTFS cards. You must use FAT32 (or exFAT for newer firmware).
2. **Copy the Files:** Navigate to your newly created deployment folder at `<NETWORK_SHARE_PATH>\Deployments\<NEW_PLAYER_NAME>\`. Copy **the contents** of the folder (not the folder itself) directly to the root of the MicroSD card.
3. **Hardware Reset (If Repurposing):** If you are repurposing an older player that was previously deployed, you **must** factory reset it. Unplug the player, insert a paperclip into the `SVC` pinhole, apply power, and hold the button until the `ERR` light flashes rapidly. If you skip this, the player will ignore the new SD card.
4. **Connect Network:** Ensure the physical Ethernet cable is plugged securely into the BrightSign player (or that Wi-Fi credentials were included in the configuration).
5. **Boot:** Insert the MicroSD card into the player and power it on.

The player will automatically connect to the network, consume the registration token we generated, and appear in our BSN.cloud portal under the name `<NEW_PLAYER_NAME>`.

---

## Naming Standards
Please ensure that you name all newly deployed BrightSign players according to the official `<COMPANY_NAME>` naming conventions. Consistent naming is vital for our device management portal.

For details on how to correctly format your `<NEW_PLAYER_NAME>`, refer to the naming convention documentation here:
**[Naming Standard Document](<LINK_TO_NAMING_STANDARD>)**
