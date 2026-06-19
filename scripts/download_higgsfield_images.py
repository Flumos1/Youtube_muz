#!/usr/bin/env python3
"""
Скрипт для скачивания всех 46 картинок Fleetwood Mac / Rumours из Higgsfield.
Переименовывает в формат MMSS.png для CapCut.

Использование:
    python3 download_higgsfield_images.py

Картинки сохранятся в папку ./higgsfield_images/ (создаст сама).
"""

import os
import requests
from pathlib import Path
import time

# Маппинг ID → тайм-код (MMSS)
IMAGES = {
    "142172aa-4621-4ad0-bb18-9803acbdac26": "0000",  # Тёмная студия, пульт
    "32676bc0-d8ce-4701-acb8-322af5148b02": "0005",  # Две пары спинами
    "b9dff322-3396-474b-9651-f9502c65761a": "0010",  # Одинокий у пульта
    "191abafa-9dd5-4ec9-9692-8da24a0e457b": "0015",  # Лайв-рум
    "1de9397f-b569-49d8-b81f-580a8c4090c9": "0020",  # Микрофон
    "d093e2b1-bc51-4bc2-aa24-9d6206374856": "0025",  # Рука пишет
    "123c7aca-55ef-4f13-8a20-25c5af451239": "0030",  # VU-метр
    "82c587cd-296d-4b0a-bcb4-0a4d5feceab3": "0035",  # Концерт
    "a80d51aa-35eb-4491-b425-0cedb455a225": "0040",  # Тур-автобус
    "ce809394-7ad5-4aab-9caa-5b23a7dc18db": "0045",  # Золотые диски
    "c1949710-2bc6-42d1-aab3-765cf92cb84d": "0050",  # 5 силуэтов собираются
    "4cf7cd73-c081-4a4e-bcdf-d2d4dcbf9d41": "0055",  # Барабанщик
    "74292c5f-f3e4-4c86-97f0-74def16e12f0": "0100",  # Гитарист и певица
    "d5bb55ad-617c-4cb0-8930-f6987db34a53": "0105",  # Рояль + басист
    "ccf8220e-6cef-4b90-bfa9-130582607820": "0110",  # Два кольца
    "9632c5d6-6ccd-43b7-a3dc-78340b29a5cb": "0115",  # Завод винила
    "6c0699b3-fe92-499f-924b-3b2e69252a28": "0120",  # Крутящаяся пластинка
    "3052eb94-fb1d-4a0c-b73e-ed550fb5f4ac": "0125",  # Толпа у зала
    "0da14ef9-e04d-42b5-a639-0c7c7ed598f5": "0130",  # Деньги/шампанское
    "566294b8-2f61-4cbc-b93c-24568da42f22": "0135",  # Золотой портрет
    "56cc0b0b-107a-49b5-b45a-294d3c0707b3": "0140",  # Трещина по сцене
    "a32ca3d0-57d8-4aeb-ba77-629c7e7b0fe5": "0145",  # Две пары с разломом
    "a062645f-7e7e-412a-a74f-68590e60c767": "0150",  # Рассвет на шоссе
    "88b94c97-d560-48ef-8780-18542b2766d5": "0155",  # Силуэт бэкстейдж
    "e9c7df63-0877-4bed-aaf7-02c1f608005d": "0200",  # Пара расходится
    "dd14fb98-138e-4453-b725-db460913e78d": "0205",  # Гитара/уход
    "8e5d4514-6396-4011-8030-66fb66c96a23": "0210",  # Порванное фото
    "9140ce1e-b48e-4f59-bb27-32380377acf6": "0215",  # Бумаги о разводе
    "45208720-497f-4d8a-80dd-119f4613b8b3": "0220",  # Два силуэта спинами
    "f053fd69-50e4-4535-be51-e62192a46192": "0225",  # Женщина у рояля
    "9aa1918c-cd99-4d21-997b-f9980c533373": "0230",  # Снятая трубка
    "fac7f15a-f224-456a-b659-7131491e2e00": "0235",  # Голова в руках
    "e7b26401-89bc-4381-82a6-ea6cb19e6d53": "0240",  # Дверь и две тени
    "efd39344-a1e1-4cfa-b0a3-a208f324b5ea": "0245",  # Вянущие розы
    "9a93c256-6212-4835-ac16-ef03528b40cd": "0250",  # Три пары растворяются
    "ce7c8c95-a773-47fa-afdd-899a0edfe7d4": "0255",  # Расколотый силуэт
    "65e1b32b-e1d4-4631-baf0-e691197c735b": "0300",  # Сжатые руки
    "d95a9761-52e4-4e6b-85af-b4c1732195f9": "0305",  # Часы/время
    "2c996b47-a6d6-4176-a614-724000b41a5c": "0310",  # Силуэт у микрофона
    "89a20e62-c16a-419a-b924-9e04e4009d44": "0315",  # Пустая аппаратная
    "9113cb0e-6abf-4414-8a93-147a82c9f558": "0320",  # Дождь и две чашки
    "4f637b59-d1c0-4e1b-83b6-2e7409fab81a": "0325",  # Одна лампа в темноте
    "7972e3e4-0ec7-4c7c-a952-83a2fd7e39c4": "0330",  # Студия у залива
    "05eb9286-f96d-403c-80a4-8324d3679397": "0335",  # Мост в тумане
    "bfa4ebac-6063-455a-a3dc-0da9c5613a07": "0340",  # Часы на 4 утра
    "9947befc-2099-4789-aeb8-86e9dad9d7b9": "0345",  # Измотанный у пульта
}

BASE_URL = "https://d8j0ntlcm91z4.cloudfront.net/user_3A9UCB8azenuFKi8hYYQ9ZP1au1/"

# Маппинг ID → имя файла на CDN (по результатам show_generations)
CDN_FILENAMES = {
    "142172aa-4621-4ad0-bb18-9803acbdac26": "hf_20260616_144255_142172aa-4621-4ad0-bb18-9803acbdac26.png",
    "32676bc0-d8ce-4701-acb8-322af5148b02": "hf_20260616_144301_32676bc0-d8ce-4701-acb8-322af5148b02.png",
    "b9dff322-3396-474b-9651-f9502c65761a": "hf_20260616_144306_b9dff322-3396-474b-9651-f9502c65761a.png",
    "191abafa-9dd5-4ec9-9692-8da24a0e457b": "hf_20260616_144311_191abafa-9dd5-4ec9-9692-8da24a0e457b.png",
    "1de9397f-b569-49d8-b81f-580a8c4090c9": "hf_20260616_144316_1de9397f-b569-49d8-b81f-580a8c4090c9.png",
    "d093e2b1-bc51-4bc2-aa24-9d6206374856": "hf_20260616_144545_d093e2b1-bc51-4bc2-aa24-9d6206374856.png",
    "123c7aca-55ef-4f13-8a20-25c5af451239": "hf_20260616_144550_123c7aca-55ef-4f13-8a20-25c5af451239.png",
    "82c587cd-296d-4b0a-bcb4-0a4d5feceab3": "hf_20260616_144555_82c587cd-296d-4b0a-bcb4-0a4d5feceab3.png",
    "a80d51aa-35eb-4491-b425-0cedb455a225": "hf_20260616_144601_a80d51aa-35eb-4491-b425-0cedb455a225.png",
    "ce809394-7ad5-4aab-9caa-5b23a7dc18db": "hf_20260616_150022_ce809394-7ad5-4aab-9caa-5b23a7dc18db.png",
    "c1949710-2bc6-42d1-aab3-765cf92cb84d": "hf_20260616_150034_c1949710-2bc6-42d1-aab3-765cf92cb84d.png",
    "4cf7cd73-c081-4a4e-bcdf-d2d4dcbf9d41": "hf_20260616_150039_4cf7cd73-c081-4a4e-bcdf-d2d4dcbf9d41.png",
    "74292c5f-f3e4-4c86-97f0-74def16e12f0": "hf_20260616_150044_74292c5f-f3e4-4c86-97f0-74def16e12f0.png",
    "d5bb55ad-617c-4cb0-8930-f6987db34a53": "hf_20260616_150203_d5bb55ad-617c-4cb0-8930-f6987db34a53.png",
    "ccf8220e-6cef-4b90-bfa9-130582607820": "hf_20260616_150207_ccf8220e-6cef-4b90-bfa9-130582607820.png",
    "9632c5d6-6ccd-43b7-a3dc-78340b29a5cb": "hf_20260616_150214_9632c5d6-6ccd-43b7-a3dc-78340b29a5cb.png",
    "6c0699b3-fe92-499f-924b-3b2e69252a28": "hf_20260616_150220_6c0699b3-fe92-499f-924b-3b2e69252a28.png",
    "3052eb94-fb1d-4a0c-b73e-ed550fb5f4ac": "hf_20260616_150347_3052eb94-fb1d-4a0c-b73e-ed550fb5f4ac.png",
    "0da14ef9-e04d-42b5-a639-0c7c7ed598f5": "hf_20260616_150352_0da14ef9-e04d-42b5-a639-0c7c7ed598f5.png",
    "566294b8-2f61-4cbc-b93c-24568da42f22": "hf_20260616_150357_566294b8-2f61-4cbc-b93c-24568da42f22.png",
    "56cc0b0b-107a-49b5-b45a-294d3c0707b3": "hf_20260616_150401_56cc0b0b-107a-49b5-b45a-294d3c0707b3.png",
    "a32ca3d0-57d8-4aeb-ba77-629c7e7b0fe5": "hf_20260616_150558_a32ca3d0-57d8-4aeb-ba77-629c7e7b0fe5.png",
    "a062645f-7e7e-412a-a74f-68590e60c767": "hf_20260616_150604_a062645f-7e7e-412a-a74f-68590e60c767.png",
    "88b94c97-d560-48ef-8780-18542b2766d5": "hf_20260616_150608_88b94c97-d560-48ef-8780-18542b2766d5.png",
    "e9c7df63-0877-4bed-aaf7-02c1f608005d": "hf_20260616_150616_e9c7df63-0877-4bed-aaf7-02c1f608005d.png",
    "dd14fb98-138e-4453-b725-db460913e78d": "hf_20260616_150713_dd14fb98-138e-4453-b725-db460913e78d.png",
    "8e5d4514-6396-4011-8030-66fb66c96a23": "hf_20260616_150717_8e5d4514-6396-4011-8030-66fb66c96a23.png",
    "9140ce1e-b48e-4f59-bb27-32380377acf6": "hf_20260616_150722_9140ce1e-b48e-4f59-bb27-32380377acf6.png",
    "45208720-497f-4d8a-80dd-119f4613b8b3": "hf_20260616_150727_45208720-497f-4d8a-80dd-119f4613b8b3.png",
    "9aa1918c-cd99-4d21-997b-f9980c533373": "hf_20260616_150827_9aa1918c-cd99-4d21-997b-f9980c533373.png",
    "fac7f15a-f224-456a-b659-7131491e2e00": "hf_20260616_150832_fac7f15a-f224-456a-b659-7131491e2e00.png",
    "e7b26401-89bc-4381-82a6-ea6cb19e6d53": "hf_20260616_150837_e7b26401-89bc-4381-82a6-ea6cb19e6d53.png",
    "efd39344-a1e1-4cfa-b0a3-a208f324b5ea": "hf_20260616_151007_efd39344-a1e1-4cfa-b0a3-a208f324b5ea.png",
    "9a93c256-6212-4835-ac16-ef03528b40cd": "hf_20260616_151013_9a93c256-6212-4835-ac16-ef03528b40cd.png",
    "ce7c8c95-a773-47fa-afdd-899a0edfe7d4": "hf_20260616_151018_ce7c8c95-a773-47fa-afdd-899a0edfe7d4.png",
    "65e1b32b-e1d4-4631-baf0-e691197c735b": "hf_20260616_151023_65e1b32b-e1d4-4631-baf0-e691197c735b.png",
    "d95a9761-52e4-4e6b-85af-b4c1732195f9": "hf_20260616_151346_d95a9761-52e4-4e6b-85af-b4c1732195f9.png",
    "2c996b47-a6d6-4176-a614-724000b41a5c": "hf_20260616_151350_2c996b47-a6d6-4176-a614-724000b41a5c.png",
    "89a20e62-c16a-419a-b924-9e04e4009d44": "hf_20260616_151355_89a20e62-c16a-419a-b924-9e04e4009d44.png",
    "9113cb0e-6abf-4414-8a93-147a82c9f558": "hf_20260616_151359_9113cb0e-6abf-4414-8a93-147a82c9f558.png",
    "4f637b59-d1c0-4e1b-83b6-2e7409fab81a": "hf_20260616_151501_4f637b59-d1c0-4e1b-83b6-2e7409fab81a.png",
    "7972e3e4-0ec7-4c7c-a952-83a2fd7e39c4": "hf_20260616_151506_7972e3e4-0ec7-4c7c-a952-83a2fd7e39c4.png",
    "05eb9286-f96d-403c-80a4-8324d3679397": "hf_20260616_151511_05eb9286-f96d-403c-80a4-8324d3679397.png",
    "bfa4ebac-6063-455a-a3dc-0da9c5613a07": "hf_20260616_151516_bfa4ebac-6063-455a-a3dc-0da9c5613a07.png",
    "9947befc-2099-4789-aeb8-86e9dad9d7b9": "hf_20260616_151559_9947befc-2099-4789-aeb8-86e9dad9d7b9.png",
}

def download_images():
    """Скачать и переименовать все картинки."""
    output_dir = Path("./higgsfield_images")
    output_dir.mkdir(exist_ok=True)
    
    print(f"📥 Скачиваем {len(IMAGES)} картинок в папку: {output_dir.absolute()}")
    print("-" * 60)
    
    success_count = 0
    failed_count = 0
    
    for idx, (image_id, timecode) in enumerate(IMAGES.items(), 1):
        filename = CDN_FILENAMES.get(image_id, f"hf_{image_id}.png")
        url = BASE_URL + filename
        output_path = output_dir / f"{timecode}.png"
        
        try:
            print(f"[{idx:2d}/46] {timecode} ({image_id[:8]}...) ", end="", flush=True)
            
            response = requests.get(url, timeout=10)
            response.raise_for_status()
            
            with open(output_path, "wb") as f:
                f.write(response.content)
            
            file_size = output_path.stat().st_size / (1024 * 1024)
            print(f"✓ ({file_size:.1f}MB)")
            success_count += 1
            
            time.sleep(0.2)  # Вежливая задержка между запросами
            
        except requests.exceptions.RequestException as e:
            print(f"✗ ОШИБКА: {e}")
            failed_count += 1
        except Exception as e:
            print(f"✗ ОШИБКА: {e}")
            failed_count += 1
    
    print("-" * 60)
    print(f"\n✓ Успешно: {success_count}/46")
    if failed_count > 0:
        print(f"✗ Ошибок: {failed_count}/46")
    
    print(f"\n📂 Картинки сохранены в: {output_dir.absolute()}")
    print("\n💡 Готовые файлы MMSS.png можно перетаскивать в CapCut по тайм-кодам.")

if __name__ == "__main__":
    try:
        download_images()
    except KeyboardInterrupt:
        print("\n\n⚠️  Отменено пользователем.")
    except Exception as e:
        print(f"\n❌ Критическая ошибка: {e}")
