import tkinter as tk
import subprocess


def open_environment(environment):
    subprocess.Popen(
        [
            # TODO: Verificar versao do sketchup instalada
            "C:\\Program Files\\SketchUp\\SketchUp 2021\\SketchUp.exe",
            # TODO: Verificar usuario
            "C:\\Users\\Amoradev\\AppData\\Roaming\\SketchUp\\SketchUp 2021\\SketchUp\\Plugins\\enviroments\\"
            + environment
            + ".skp",
        ]
    )

root = tk.Tk()
root.title("Selecionar Ambiente")

font_style = ("Helvetica", 14)

button_style = {
    "bg": "#007bff",
    "fg": "white",
    "font": font_style,
    "padx": 20,
    "pady": 10,
    "bd": 0,
    "highlightthickness": 0,
}

area_lazer_button = tk.Button(
    root, text="Area de lazer", command=lambda: open_environment("area_lazer"), **button_style
)
area_lazer_button.pack(pady=10)

banheiro_com_lavabo_button = tk.Button(
    root, text="Banheiro com Lavabo", command=lambda: open_environment("banheiro_com_lavabo"), **button_style
)
banheiro_com_lavabo_button.pack(pady=10)

banheiro_social_button = tk.Button(
    root, text="Banheiro Social", command=lambda: open_environment("banheiro_social"), **button_style
)
banheiro_social_button.pack(pady=10)

cozinha_button = tk.Button(
    root, text="Cozinha", command=lambda: open_environment("cozinha"), **button_style
)
cozinha_button.pack(pady=10)

gourmet_button = tk.Button(
    root, text="Gourmet", command=lambda: open_environment("gourmet"), **button_style
)
gourmet_button.pack(pady=10)

vo_zenaide_roca_1_button = tk.Button(
    root, text="Vo Zenaide Roca 1", command=lambda: open_environment("vo_zenaide_roca_1"), **button_style
)
vo_zenaide_roca_1_button.pack(pady=10)


root.mainloop()
