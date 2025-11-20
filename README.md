# Meal Ordering System  Assembly Language (8086)

**Author:** Syed Mujtaba Zaidi  
**Language:** Assembly (MASM / TASM)  
**Platform:** DOS / 8086 Architecture  

BS Cyber Security 3rd Semester ( BS CY3-1 )
Assembly Language Final Project (Semester Project)
---

## Project Overview 📝

This is a Meal Ordering System developed in 8086 Assembly Language. The program allows users to:  

- Select food items from a predefined menu  
- Enter quantity  
- Add multiple items  
- Automatically calculate:  
  - Subtotal  
  - GST (15%)  
  - Service Charge (5%)  
  - Grand Total  
- Display the final bill in a clean format  

This project demonstrates strong knowledge of:  

- Procedures  
- Loops  
- Arithmetic operations  
- Conditional jumps  
- INT 21h DOS interrupts  

---

## Features 📂

**Menu Display** – Shows a list of items with prices.  

**Input Handling** – Takes item number and quantity from user.  

**Price Calculation** – Uses conditional jumps to select item prices.  

**Bill Calculation** –  
- Subtotal  
- GST (15%)  
- Service Charges (5%)  
- Grand Total  

**Procedures** –  
- `calculate_item_total`  
- `calculate_bill`  
- `display_bill`  
- `print_number`  

**Clean Output** – Uses DOS interrupt 21h function 9 for string printing.  

---

## Technologies Used 🛠

- 8086 Assembly Language  
- MASM / TASM  
- DOSBox (optional for running)  
- INT 21h services  

---

## How to Run ▶️

1. Install DOSBox or use real DOS.  
2. Assemble the program:  
   ```asm
   masm "Final Project.asm";
   link "Final Project.obj";


   
