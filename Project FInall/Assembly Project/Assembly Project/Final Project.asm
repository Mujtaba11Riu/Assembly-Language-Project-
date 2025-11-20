

.model small
.stack 100h
.data

    ; Welcome and menu messages  
    
    msg_welcome db 10, 13, "=== MEAL ORDERING SYSTEM ===", 10, 13, "$" 
    
    msg_menu db 10, 13, "========== MENU ==========", 10, 13  
       
    
             db "1. Chicken Karahi - Rs. 1500", 10, 13
             db "2. Mutton Karahi - Rs. 4800", 10, 13
             db "3. Chicken Handi - Rs. 1800", 10, 13
             db "4. Afg Double Naan - Rs. 230", 10, 13
             db "5. Afg Single Naan - Rs. 110", 10, 13
             db "6. 1.5ltr Pepsi - Rs. 230", 10, 13
             db "7. 500ml Pepsi - Rs. 110", 10, 13
             db "==========================", 10, 13, "$" 
              
             
    
    msg_item db 10, 13, "Enter item number (1-7): $"
    msg_qty db 10, 13, "Enter quantity: $"
    msg_more db 10, 13, "Add more items? (1=Yes, 0=No): $" 
    
    
    ; Bill messages                               
    
    msg_bill db 10, 13, 10, 13, "========== BILL ==========", 10, 13, "$" 
    
    msg_subtotal db "Subtotal: Rs. $"
    msg_gst db "GST (15%): Rs. $"
    msg_sc db "Service Charge (5%): Rs. $"
    msg_total db "Grand Total: Rs. $"        
    
    msg_footer db "==========================", 10, 13, "$"   
    
    
    
    msg_newline db 10, 13, "$"         
    
    
    ; Menu prices (actual prices in rupees)  
    
    price1 dw 1500
    price2 dw 4800
    price3 dw 1800
    price4 dw 230
    price5 dw 110
    price6 dw 230
    price7 dw 110
    
    ; Order variables    
    
    item_num db ?
    quantity db ?
    item_total dw 0
    subtotal dw 0
    gst_amount dw 0
    sc_amount dw 0
    grand_total dw 0
    more_items db ?
       
       
.code
main proc  
    
    
    mov ax, @data
    mov ds, ax
    
    ; Welcome message
    
    
    lea dx, msg_welcome
    mov ah, 9
    int 21h
    
order_loop:    

    ; Display menu 
    
    lea dx, msg_menu
    mov ah, 9
    int 21h
    
    ; Get item number 
    
    lea dx, msg_item
    mov ah, 9
    int 21h
    
    mov ah, 1
    int 21h
    sub al, 48      ; ASCII to number
    mov item_num, al
    
    ; Validate item number (1-7)  
    
    cmp item_num, 1
    jl order_loop
    cmp item_num, 7
    jg order_loop
    
    ; Get quantity
    
    lea dx, msg_qty
    mov ah, 9
    int 21h
    
    mov ah, 1
    int 21h
    sub al, 48      ; ASCII to number
    mov quantity, al
    
    ; Calculate item total based on item number 
    
    call calculate_item_total
    
    ; Add to subtotal
    
    mov ax, item_total
    add subtotal, ax
    
    ; Ask for more items
    
    lea dx, msg_more
    mov ah, 9
    int 21h
    
    mov ah, 1
    int 21h
    sub al, 48
    mov more_items, al
    
    cmp more_items, 1
    je order_loop
    
    ; Calculate bill  
    
    call calculate_bill
    
    ; Display bill  
    
    call display_bill
    
    ; Exit   
    
    mov ah, 4ch
    int 21h
    
main endp

; Procedure to calculate item total 

calculate_item_total proc
    push ax
    push bx
    push dx
    
    mov al, quantity
    mov ah, 0       ; ax = quantity (word)
    
    ; Get price based on item number 
    
    cmp item_num, 1
    je item1
    cmp item_num, 2
    je item2
    cmp item_num, 3
    je item3
    cmp item_num, 4
    je item4
    cmp item_num, 5
    je item5
    cmp item_num, 6
    je item6
    cmp item_num, 7
    je item7
    
item1:         

    mov bx, price1
    jmp calc   
    
    
item2:    

    mov bx, price2
    jmp calc
    
item3:     

    mov bx, price3
    jmp calc 
    
item4:     

    mov bx, price4
    jmp calc 
    
item5:     

    mov bx, price5
    jmp calc 
    
item6:    

    mov bx, price6
    jmp calc 
    
item7:     

    mov bx, price7
    jmp calc
    
calc:     

    mul bx          ; dx:ax = quantity * price (word * word)
    mov item_total, ax
    
    pop dx
    pop bx
    pop ax
    ret                
    
calculate_item_total endp


; Procedure to calculate bill (GST and Service Charge)    


calculate_bill proc 
    
    push ax
    push bx
    push dx             
    
    
    ; Calculate GST (15% of subtotal)
    ; GST = subtotal * 15 / 100      
    
    mov ax, subtotal
    mov bx, 15
    mul bx          ; ax = subtotal * 15
    mov bx, 100
    div bx          ; ax = (subtotal * 15) / 100
    mov gst_amount, ax  
    
    
    ; Calculate Service Charge (5% of subtotal)
    ; SC = subtotal * 5 / 100 
    
    
    mov ax, subtotal
    mov bx, 5
    mul bx          ; ax = subtotal * 5
    mov bx, 100
    div bx          ; ax = (subtotal * 5) / 100
    mov sc_amount, ax   
    
                            
                            
    ; Calculate Grand Total 
    
    
    mov ax, subtotal
    add ax, gst_amount
    add ax, sc_amount
    mov grand_total, ax
    
    pop dx
    pop bx
    pop ax        
    
    ret           
    
calculate_bill endp

; Procedure to display bill 

display_bill proc 
    
    push ax
    push dx
    
    ; Bill header 
    
    lea dx, msg_bill
    mov ah, 9
    int 21h
    
    ; Subtotal     
    
    lea dx, msg_subtotal
    mov ah, 9
    int 21h
    mov ax, subtotal
    call print_number
    lea dx, msg_newline
    mov ah, 9
    int 21h
    
    ; GST       
    
    lea dx, msg_gst
    mov ah, 9
    int 21h
    mov ax, gst_amount
    call print_number
    lea dx, msg_newline
    mov ah, 9
    int 21h
    
    ; Service Charge
    
    
    lea dx, msg_sc
    mov ah, 9
    int 21h
    mov ax, sc_amount
    call print_number
    lea dx, msg_newline
    mov ah, 9
    int 21h
    
    ; Grand Total  
    
    lea dx, msg_total
    mov ah, 9
    int 21h
    mov ax, grand_total
    call print_number
    lea dx, msg_newline
    mov ah, 9
    int 21h
    
    ; Footer    
    
    lea dx, msg_footer
    mov ah, 9
    int 21h
    
    pop dx
    pop ax
    ret          
    
    
display_bill endp

; Procedure to print number 


print_number proc  
    
    
    push ax
    push bx
    push cx
    push dx
    
    mov cx, 0
    mov bx, 10
    
    ; Handle zero  
    
    cmp ax, 0
    jne convert
    push ax
    inc cx
    jmp display
              
              
convert:      

    cmp ax, 0
    je display
    mov dx, 0
    div bx
    push dx
    inc cx
    jmp convert
    
display:     

    cmp cx, 0
    je done
    pop dx
    add dl, 48      ; Number to ASCII
    mov ah, 2
    int 21h
    dec cx
    jmp display
    
done:         

    pop dx
    pop cx
    pop bx
    pop ax
    ret     
    
    
print_number endp

end main

