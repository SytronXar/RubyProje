


# konsoldan şunu yazarak kodu çalıştırabilirsiniz : ruby satrançdeneme.rb
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
$Dikey=8
$Yatay=8




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

def HedefKontrolu() 
    a=$LMove.nDikey
    b=$LMove.nYatay
    c=$LMove.mDikey
    d=$LMove.mYatay
    hedeftas=$Tahta[c][d]
    isItBig=hedeftas.upcase==hedeftas
    if $sira%2==0 && !isItBig || $sira%2==1 && isItBig || hedeftas==" "
        return true
    end
    return false
end

def SecilenKontrolü()
    a=$LMove.nDikey
    b=$LMove.nYatay
    c=$LMove.mDikey
    d=$LMove.mYatay
    secilenftas=$Tahta[a][b]  
    isItBig=secilenftas.upcase==secilenftas
    if ($sira%2==0 && isItBig || $sira%2==1 && !isItBig) && secilenftas!=" "
        return true
    end
    return false
end
def buyukHarfKontrolü(harf)
    return harf==harf.upcase && harf!=" "
end
def kucukHarfKontrolü(harf)
    return harf==harf.downcase && harf!=" "
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
    if HedefKontrolu() && SecilenKontrolü() && input[0..1]!=input[2..3] #Hedef, Secilen Kontrolü ve Hedefle secilenin aynı olmaması kontrolü
        puts "Tas secimi"
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
            return $cikmaz
        end
    end
    return $cikmaz
end

#Piyonu daha tamamlayamadım tamamlayabilirsiniz, piyonda başlangıçta iki ileri olmalı, geçerken al olayı eklenebilir
def PiyonHareketi()
    a=$LMove.nDikey
    b=$LMove.nYatay
    c=$LMove.mDikey
    d=$LMove.mYatay
    puts("Piyonnnn")
    dF=c-a#dikey Fark
    yF=d-b #yatay Fark
    dFA=dF.abs
    yFA=yF.abs
    if $sira%2==0 && dF>0 || $sira%2==1 && dF<0   #1. oyuncu sadece pozitif yönde ileri, 2. oyuncu sadece negatif yönde ileri
        if dFA==1 && yF==0  #1 ileri
            return $normal
        elsif(dF==2 && a==1 || dF==-2 && a==6) && yF==0 && $Tahta[(a+c)/2][b]==" " #piyon başlangıç konumlarında 2 ileri ve engel kontrolü
            return $normal
        elsif dFA==1 && yFA==1 && $Tahta[c][d]!=" " #capraza ilerlerken sadece rakip taşına ilerlenir, neden rakip tas kontrolü değilde boşluk kontrolü yaptık, oyun zaten hedef kontrolü yapıyor.
            return $normal
        end
    end
    return $cikmaz
end

def FilHareketi()
    a=$LMove.nDikey
    b=$LMove.nYatay
    c=$LMove.mDikey
    d=$LMove.mYatay
    puts("Fillll")
    dF=c-a#dikey Fark
    yF=d-b #yatay Fark
    eksenfarki=dF.abs- yF.abs
    if eksenfarki==0   #çapraz harekette eksenler arası değişim farkı 0 olmaktadır.
        dB=dF/dF.abs #dikey Birim fark
        yB=yF/yF.abs #yatay Birim fark
        fA=dF.abs #herhangi bir eksenin farkının mutlağı(for için)
        x=a
        y=b
        for i in 1..fA-1 do #hedef ile konum arası engel bulmaya yarayan for
            x=a+i*dB
            y=b+i*yB
            if $Tahta[x][y]!=" "
               return $cikmaz 
            end
        end
        return $normal; 
    end
    return $cikmaz;
end

def KaleHareketi()
    a=$LMove.nDikey
    b=$LMove.nYatay
    c=$LMove.mDikey
    d=$LMove.mYatay
    puts("Kaleeee")
    dF=c-a#dikey Fark
    yF=d-b #yatay Fark
    if a==c && b!=d || b==d && a!=c # kale hareketinde eksenlerden sadece birinde değişim olur.
        x=a
        y=b
        dB=dF!=0 ? dF/dF.abs : 0 #dikey Birim fark
        yB=yF!=0 ? yF/yF.abs : 0 #yatay Birim fark
        fA=[dF.abs,yF.abs].max
        for i in 1..fA-1 do #hedef ile konum arasında engel olup olmadığını bulmaya yarayan for döngüsü
            x=a+i*dB
            y=b+i*yB
            if $Tahta[x][y]!=" "
               return $cikmaz 
            end
        end
        return $normal; 
    end
    return $cikmaz;
end

def VezirHareketi()
    puts("Vezirrrr")
    if FilHareketi()!=$cikmaz || KaleHareketi()!=$cikmaz #Vezirin hareketi fil ile kale hareketlerinin birleşiminden oluşur.
        return $normal; 
    end
    return $cikmaz;
end

def AtHareketi()
    a=$LMove.nDikey
    b=$LMove.nYatay
    c=$LMove.mDikey
    d=$LMove.mYatay  
    dFA=(c-a).abs #dikey Fark abs
    yFA=(d-b).abs #yatay Fark abs
    puts("Attttt")
    if dfA==2 && yFA==1 || dFA==1 && yFA==2 #At 1,2 ya da 2,1 hareketi gerçekleştirir.
        return $normal; 
    end
    return $cikmaz;
end

def SahHareketi()
    a=$LMove.nDikey
    b=$LMove.nYatay
    c=$LMove.mDikey
    d=$LMove.mYatay  
    dFA=(c-a).abs #dikey Fark abs
    yFA=(d-b).abs #yatay Fark abs
    puts("Attttt")
    if dfA<=1 && yFA<=1 #Sah dikey ve yatayda en fazla birer birim hareket edebilir
        return $normal; 
    end
    return $cikmaz;
end

def Move()
    a=$LMove.nDikey
    b=$LMove.nYatay
    c=$LMove.mDikey
    d=$LMove.mYatay
    if $Tahta[c][d].upcase=="S"
        $gameOver=true
    end
    $Tahta[c][d]=$Tahta[a][b]
    $Tahta[a][b]=" "
    $sira++
end

def OyunBaşlat()
    $gameOver=false
    cikis=false
    StartBoard() #Tahtayı Başlat
    while !$gameOver || cikis==true
       print "NerdenNereye:"
       input=gets #kullanıcıdan hedefi iste
       if input.include? 'exit'
            cikis=true
            puts "Çıkış"
       elsif CheckInput(input) #Doğru tuşlandı mı
            if CheckMovement(input) != 0 #Hareket geçerli bir hareket mi?
                Move() #Hareket ettir ve tahtayı yazdır.
                PrintBoard()
            else puts("hatalı hareket")
            end
       end
    end
    if $gameover==true
        puts "Oyun bitti, #{$sira%2+1}. oyuncu kazandı."
        puts "Toplamda #{$sira} hamle gerçekleşti."
    end
end

OyunBaşlat()