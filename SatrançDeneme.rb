
$Tahta=x = Array.new(8){ Array.new(8) }# 8x8 dizi belirledik
$gameOver=false #Oyun bitimi kontrolü
$Coords=Struct.new(:nDikey,:nYatay,:mDikey,:mYatay)
$LMove=$Coords.new(0,0,0,0)
$sira=0;

#alttaki tanımlanan değişkenler, santrançtaki bazı özel hareketler için tanımlanmıştır
$normal=1
$cikmaz=0
$ikiileri=10 #piyon
$terfi=55
$gecerkenal=65
$uzunrok=111 #$kale ve şah
$kısarok=22




def PrintBoard()
    print "   "
    for n in 1..8
        print "#{n} " #Üstteki sayılar
    end
    puts ""
    for n in 0..7    
        print " #{("A".ord+n).chr}|" #ASCII kodta A'dan başlayıp birer birer A, B, C, D... diye sağ kenara yazdırdık
        for m in 0..7
            print "#{$Tahta[n][m]}|" #iki boyutulu dizi Tahtanın elemanlarını yazdırdık. 
        end
        puts ""
    end
    puts ""
end

def StartBoard()
    for n in 0..7
        for m in 0..7
            if n==1 || n==6
                $Tahta[n][m]="P"
            elsif n==0||n==7
                if m==0||m==7
                    $Tahta[n][m]="K"
                elsif m==1||m==6
                    $Tahta[n][m]="A"
                elsif m==2||m==5
                    $Tahta[n][m]="F"
                elsif m==3
                    $Tahta[n][m]="S"
                elsif m==4
                    $Tahta[n][m]="V"
                end
            else $Tahta[n][m]=" "
            end 
            if n==7||n==6
                $Tahta[n][m].downcase! #Ünlem işareti direkt veriyi değiştiriyor. ünlem konulmazsa veri değişmez.
            end      
        end
    end  
    PrintBoard()
end

def CheckInput(input)
    return HarfA_H(input[0]) && HarfA_H(input[2]) && Sayi1_8(input[1].to_i) && Sayi1_8(input[3].to_i) #Doğru Harfler ve sayılar girildi mi kontrol edilir.
end

def HarfA_H(harf)
    nharf=harf.upcase.ord
    return nharf>=65 && nharf<=72
end

def Sayi1_8(sayi)
    return sayi>0 && sayi<=8
end

def CheckMovement(input)
    #Aşağıda inputu çift boyutlu diziden elemanı seçilecek verilere dönüştürüyoruz.
    nDikey=input[0].upcase.ord-65 #A5C3 A=>0
    nYatay=input[1].to_i - 1 ##A5C3 5=>4
    mDikey=input[2].upcase.ord-65 #A5C3 C=>2
    mYatay=input[3].to_i - 1 #A5C3 3=>2
    #Bu verileri Global bir değişkende structta depoluyoruz.
    $LMove=$Coords.new(nDikey,nYatay,mDikey,mYatay)

    secilenTas=$Tahta[nDikey][nYatay]
    hedef=$Tahta[mDikey][mYatay]
    #harfe göre aşağıda case when yapılıyor.
    if HedefKontrolu()
        case (secilenTas.upcase)
        when "P"
            return PiyonHareketi()
        when "F"
            return FilHareketi()
        when "A"
            return AtHareketi()
        when "K"
            return KaleHareketi()
        when "V"
            return VezirHareketi()
        when "S"
            return SahHareketi()
        else
            return 0
        end
    end
    return 0
end


#Piyonu daha tamamlayamadım tamamlayabilirsiniz, piyonda başlangıçta iki ileri olmalı, geçerken al olayı eklenebilir
def PiyonHareketi()
    a=$LMove.nDikey
    b=$LMove.nYatay
    c=$LMove.mDikey
    d=$LMove.mYatay
    if c=a+1 && d==b
        return $normal
    end
    return $cikmaz
end

def FilHareketi()
    a=$LMove.nDikey
    b=$LMove.nYatay
    c=$LMove.mDikey
    d=$LMove.mYatay
    return $cikmaz
end

def AtHareketi()
    a=$LMove.nDikey
    b=$LMove.nYatay
    c=$LMove.mDikey
    d=$LMove.mYatay
    if((c==a+2||c==a-2)&&(d==b+1||d==b-1))||((d==b+2||d==b-2)&&(c==a+1||c==a-1))
        return $normal; 
    end
    return $cikmaz;
end

def KaleHareketi()
    a=$LMove.nDikey
    b=$LMove.nYatay
    c=$LMove.mDikey
    d=$LMove.mYatay
    return $cikmaz
end
def VezirHareketi()
    a=$LMove.nDikey
    b=$LMove.nYatay
    c=$LMove.mDikey
    d=$LMove.mYatay
    return $cikmaz
end
def SahHareketi()
    a=$LMove.nDikey
    b=$LMove.nYatay
    c=$LMove.mDikey
    d=$LMove.mYatay
    return $cikmaz
end

def Move()
    a=$LMove.nDikey
    b=$LMove.nYatay
    c=$LMove.mDikey
    d=$LMove.mYatay
    $Tahta[c][d]=$Tahta[a][b]
    $Tahta[a][b]=" "
end
def HedefKontrolu() 
    a=$LMove.nDikey
    b=$LMove.nYatay
    c=$LMove.mDikey
    d=$LMove.mYatay
    hedeftas=$Tahta[c][d]
    isItBig=hedeftas.ord<65
    if sira%2==0 && isItBig || sira%2==1 && !isItBig || hedeftas=" "
        return true
    end
    return false
end

def OyunBaşlat()
    $gameOver=false
    StartBoard() #Tahtayı Başlat
    while !$gameOver
       print "NerdenNereye:"
       input=gets #kullanıcıdan hedefi iste
       if input.include? 'exit'
            $gameOver=true
            puts "Çıkış"
       elsif CheckInput(input) #Doğru tuşlandı mı
        puts(5301)
            if CheckMovement(input) != 0 #Hareket geçerli bir hareket mi?
                puts(4001)
                Move() #Hareket ettir ve tahtayı yazdır.
                PrintBoard()
            else puts("hatalı hareket")
            end
       end
    end
end

OyunBaşlat()