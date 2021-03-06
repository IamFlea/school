package sfcga;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Point;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

/**
 * Tento projekt slouzi jako nazorna ukazka vyuziti GA v praxi. Predstavuji zde 
 * vyuziti GA s permutacnim kodovanim chromozomu v uloze obchodniho cestujiciho,
 * kdy musime urazit nejmensi trasu a navstivit vsechna mesta. Dale zde 
 * prezentuji evolucni strategii k nastaveni parametru perceptronu. 
 * 
 * Pocet vypitych salku kavy behem psani tohoto programu: 6
 * Celkem straveno hodin: 24
 * 
 * Tento soubor obsahuje prevazne GUI projektu, proto je necitelne napsany. 
 * Mimochodem nejsem zadny grafik! Hlavni algoritmy by mely byti napsany 
 * citelneji.
 * 
 * @author Petr Dvoracek :: xdvora0n at stud.fit.vutbr.cz 
 * @version 007
 */
public class SfcGA extends javax.swing.JFrame implements SendMsg {
    private boolean canRun = false;
    public String log = "";
    public TSP tsp; 
    public static Random rand = new Random(); 
    public static int popsize;
    
    /**
     * Creates new form SfcGA
     */
    public SfcGA() {
        initComponents();
        // Inicializace uloh. (Jejich seznamu.)
        tsp =  new TSP(this);
        canRun = true;

    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {
        java.awt.GridBagConstraints gridBagConstraints;

        jLabel1 = new javax.swing.JLabel();
        jTabbedPane1 = new javax.swing.JTabbedPane();
        jPanel4 = new javax.swing.JPanel();
        jScrollPane2 = new javax.swing.JScrollPane();
        textOutput = new javax.swing.JTextArea();
        jButton2 = new javax.swing.JButton();
        jPanel3 = new javax.swing.JPanel();
        jPanel6 = new javax.swing.JPanel();
        jButton3 = new javax.swing.JButton();
        jLabel2 = new javax.swing.JLabel();
        jButton7 = new javax.swing.JButton();
        jButton5 = new javax.swing.JButton();
        jButton6 = new javax.swing.JButton();
        jButton1 = new javax.swing.JButton();
        jButton4 = new javax.swing.JButton();
        jPanel5 = new javax.swing.JPanel();
        jLabel3 = new javax.swing.JLabel();
        fGenerations = new javax.swing.JTextField();
        jLabel4 = new javax.swing.JLabel();
        fPopSize = new javax.swing.JTextField();
        jLabel9 = new javax.swing.JLabel();
        fSelectionPop = new javax.swing.JComboBox();
        jLabel5 = new javax.swing.JLabel();
        fOffspringsCnt = new javax.swing.JTextField();
        jLabel10 = new javax.swing.JLabel();
        fSelectionParent = new javax.swing.JComboBox();
        jLabel6 = new javax.swing.JLabel();
        fMutationProbability = new javax.swing.JTextField();
        jLabel7 = new javax.swing.JLabel();
        fCrossoverProbability = new javax.swing.JTextField();
        jLabel8 = new javax.swing.JLabel();
        fPointsOfXover = new javax.swing.JTextField();
        fStrategy = new javax.swing.JComboBox();
        jLabel17 = new javax.swing.JLabel();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        jLabel1.setFont(new java.awt.Font("Tahoma", 1, 18)); // NOI18N
        jLabel1.setText("Genetické algoritmy v praxi");

        jTabbedPane1.setToolTipText("");
        jTabbedPane1.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));
        jTabbedPane1.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jTabbedPane1StateChanged(evt);
            }
        });

        textOutput.setEditable(false);
        textOutput.setColumns(20);
        textOutput.setFont(new java.awt.Font("Monospaced", 0, 12)); // NOI18N
        textOutput.setLineWrap(true);
        textOutput.setRows(5);
        textOutput.setWrapStyleWord(true);
        jScrollPane2.setViewportView(textOutput);

        jButton2.setText("Vzmazat log");
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel4Layout.createSequentialGroup()
                .addContainerGap(829, Short.MAX_VALUE)
                .addComponent(jButton2)
                .addContainerGap())
            .addComponent(jScrollPane2, javax.swing.GroupLayout.Alignment.TRAILING)
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 397, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jButton2)
                .addGap(6, 6, 6))
        );

        jTabbedPane1.addTab("Textový výstup", jPanel4);

        jPanel6.setBackground(new java.awt.Color(204, 255, 204));
        jPanel6.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jPanel6MouseClicked(evt);
            }
        });
        jPanel6.addComponentListener(new java.awt.event.ComponentAdapter() {
            public void componentResized(java.awt.event.ComponentEvent evt) {
                jPanel6ComponentResized(evt);
            }
            public void componentShown(java.awt.event.ComponentEvent evt) {
                jPanel6ComponentShown(evt);
            }
        });
        jPanel6.addPropertyChangeListener(new java.beans.PropertyChangeListener() {
            public void propertyChange(java.beans.PropertyChangeEvent evt) {
                jPanel6PropertyChange(evt);
            }
        });

        javax.swing.GroupLayout jPanel6Layout = new javax.swing.GroupLayout(jPanel6);
        jPanel6.setLayout(jPanel6Layout);
        jPanel6Layout.setHorizontalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 909, Short.MAX_VALUE)
        );
        jPanel6Layout.setVerticalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 389, Short.MAX_VALUE)
        );

        jButton3.setText("RESET");
        jButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton3ActionPerformed(evt);
            }
        });

        jLabel2.setText("Fitness: ?? km");

        jButton7.setText("Prekreslit");
        jButton7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton7ActionPerformed(evt);
            }
        });

        jButton5.setText("Zobraz nej");
        jButton5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton5ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGap(20, 20, 20)
                .addComponent(jLabel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton5)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton7)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton3)
                .addContainerGap())
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPanel6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel3Layout.createSequentialGroup()
                .addComponent(jPanel6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 14, Short.MAX_VALUE)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButton3)
                    .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButton7)
                    .addComponent(jButton5))
                .addGap(1, 1, 1))
        );

        jTabbedPane1.addTab("Problém obchodního cestujícího", jPanel3);

        jButton6.setText("INIT");
        jButton6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton6ActionPerformed(evt);
            }
        });

        jButton1.setText("Spustit");
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        jButton4.setText("Krok");
        jButton4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton4ActionPerformed(evt);
            }
        });

        jPanel5.setAlignmentX(0.0F);
        jPanel5.setAlignmentY(0.0F);
        jPanel5.setLayout(new java.awt.GridBagLayout());

        jLabel3.setText("Počet generací:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 18;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel3, gridBagConstraints);

        fGenerations.setText("500");
        fGenerations.setMinimumSize(new java.awt.Dimension(60, 20));
        fGenerations.setPreferredSize(new java.awt.Dimension(60, 20));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 18;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 100;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
        jPanel5.add(fGenerations, gridBagConstraints);

        jLabel4.setText("Velikost populace:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 8;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel4, gridBagConstraints);

        fPopSize.setText("20");
        fPopSize.setMinimumSize(new java.awt.Dimension(60, 20));
        fPopSize.setPreferredSize(new java.awt.Dimension(60, 20));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 8;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 100;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
        jPanel5.add(fPopSize, gridBagConstraints);

        jLabel9.setText("Selekce nové pop:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 9;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel9, gridBagConstraints);

        fSelectionPop.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Turnaj", "Ruleta", "Náhodně", "Deterministicky" }));
        fSelectionPop.setMinimumSize(new java.awt.Dimension(60, 20));
        fSelectionPop.setPreferredSize(new java.awt.Dimension(60, 20));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 9;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 100;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
        jPanel5.add(fSelectionPop, gridBagConstraints);

        jLabel5.setText("Počet potomků:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 10;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel5, gridBagConstraints);

        fOffspringsCnt.setText("100");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 10;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 100;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
        jPanel5.add(fOffspringsCnt, gridBagConstraints);

        jLabel10.setText("Výběr rodičů:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 11;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel10, gridBagConstraints);

        fSelectionParent.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Turnaj", "Ruleta", "Náhodně" }));
        fSelectionParent.setMinimumSize(new java.awt.Dimension(60, 20));
        fSelectionParent.setPreferredSize(new java.awt.Dimension(60, 20));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 11;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 100;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
        jPanel5.add(fSelectionParent, gridBagConstraints);

        jLabel6.setText("Pravděpod. mutace:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 13;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel6, gridBagConstraints);

        fMutationProbability.setText("0.1");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 13;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 100;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
        jPanel5.add(fMutationProbability, gridBagConstraints);

        jLabel7.setText("Pravděpod. křížení:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 14;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel7, gridBagConstraints);

        fCrossoverProbability.setText("0.7");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 14;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 100;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
        jPanel5.add(fCrossoverProbability, gridBagConstraints);

        jLabel8.setText("Max. počet bodů křížení:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 15;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel8, gridBagConstraints);

        fPointsOfXover.setText("1");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 15;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 100;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
        jPanel5.add(fPointsOfXover, gridBagConstraints);

        fStrategy.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "S rodiči (n+m)", "Bez rodičů (n; m)" }));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 12;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        jPanel5.add(fStrategy, gridBagConstraints);

        jLabel17.setText("Stretegie:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 12;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel17, gridBagConstraints);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel1)
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addGroup(layout.createSequentialGroup()
                        .addContainerGap()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jButton6)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jButton1)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButton4)
                                .addGap(0, 0, Short.MAX_VALUE))
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                                .addComponent(jPanel5, javax.swing.GroupLayout.PREFERRED_SIZE, 315, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(jTabbedPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 933, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel1)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTabbedPane1)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jButton6)
                            .addComponent(jButton1)
                            .addComponent(jButton4)))
                    .addGroup(layout.createSequentialGroup()
                        .addGap(29, 29, 29)
                        .addComponent(jPanel5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents
    /**
     * Printing empty string into textarea in GUI.
     */
    public void print(){
        print("");
    }
    /**
     * Printing string into textarea in GUI.
     * @param s Text
     */
    public void print(String s){
        log += s+"\n";
        textOutput.setText(log);
    }


    /**
     * Vykresli uzly grafu aka mesta.
     */
    private void showNodes(){
        //jPanel6.repaint();
        Graphics g = jPanel6.getGraphics();
        g.setColor(Color.white);
        g.fillRect(0, 0, jPanel6.getWidth(), jPanel6.getHeight());
        g.setColor(Color.black);
        
        for (int i = 0; i < tsp.nodesIdx; i++) {
            g.fillOval(tsp.nodes[i].x, tsp.nodes[i].y, 5, 5);
            g.drawString(Integer.toString(i), tsp.nodes[i].x +5 , tsp.nodes[i].y - 2 );
        }
    }
     
    @Override
    public void repaint(){
        super.repaint();
        showNodes();
    }
        static int TSP = 1;
    static int NN = 2;
    static int NONE = 0;
            
    
    int selectedPane(){
        if (jTabbedPane1.getSelectedComponent() == jPanel3)
            return TSP;
        return NONE;
    }
    /**INIT PRESSED**/
    private void jButton6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton6ActionPerformed
        if(selectedPane() == TSP){
            print("Vybrana uloha TSP.");
            print("Nastavuju parametry.");
            setTSP();
            if(tsp.init() == 1){
                print("HOTOVO.");
                tsp.runnable = true;
                printParent();
                showLines();
            }else{
                print("CHYBA>> Potrebuji alespon 3 mesta.");
            }
        }
    }//GEN-LAST:event_jButton6ActionPerformed
    
    /**STEP PRESSED**/
    private void jButton4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton4ActionPerformed
            if(tsp.runnable){
                tsp.step();
                printParent();
                showLines();
            }
    }//GEN-LAST:event_jButton4ActionPerformed

    
    private void printParent(){
                Chromosome parent = tsp.getParent();
                String str = "Nejlepsi jedinec: ";
                for(int i : parent.chrom){
                    str += i + " ";
                }
                str+=parent.fitness;
                print(str);
    }
    /**RUN PRESSED**/
    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        tsp.maxGenerations = Integer.valueOf(fGenerations.getText());
                
            if(tsp.runnable){
                tsp.run();
                printParent();
                showLines();
            }
        
    }//GEN-LAST:event_jButton1ActionPerformed
    /**REDRAW THE LINES**/
    private void jButton7ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton7ActionPerformed
        // TODO add your handling code here:
            if(tsp.runnable){
                showLines();
            }
        // jButton7ActionPerformed(null);
    }//GEN-LAST:event_jButton7ActionPerformed

    private void jTabbedPane1StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jTabbedPane1StateChanged
        if(jTabbedPane1.getSelectedComponent() == jPanel3){
            showNodes();
        }
        // TODO add your handling code here:
    }//GEN-LAST:event_jTabbedPane1StateChanged

    /**
     * Deleting nodes from graph in TSP.
     * @param evt Udalost.
     */
    private void jButton3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton3ActionPerformed
        print("Mazu body.");
        tsp.nodesIdx = 0;
        jPanel6.repaint();
        best_fit = Double.MAX_VALUE;
        best_chr = null;
    }//GEN-LAST:event_jButton3ActionPerformed

    private void jPanel6PropertyChange(java.beans.PropertyChangeEvent evt) {//GEN-FIRST:event_jPanel6PropertyChange
        // TODO add your handling code here:
        //                showNodes();
    }//GEN-LAST:event_jPanel6PropertyChange

    private void jPanel6ComponentShown(java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_jPanel6ComponentShown
        showNodes();
    }//GEN-LAST:event_jPanel6ComponentShown

    private void jPanel6ComponentResized(java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_jPanel6ComponentResized
        showNodes();
    }//GEN-LAST:event_jPanel6ComponentResized

    /**
     * Pridani mesta.
     * @param evt mys
     */
    private void jPanel6MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jPanel6MouseClicked
        // TODO add your handling code here:
        print("TSP novy uzel: " + evt.getPoint().toString());
        tsp.nodes[tsp.nodesIdx] = evt.getPoint();
        tsp.nodesIdx++;
        System.err.println("pocet> "+tsp.nodesIdx);
        showNodes();
        tsp.runnable = false;
    }//GEN-LAST:event_jPanel6MouseClicked

    /** 
     * Clear the string from textarea in GUI.
     * @param evt Event param.
     */
    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        log = "";
        textOutput.setText(log);
    }//GEN-LAST:event_jButton2ActionPerformed

    private void jButton5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton5ActionPerformed
        if(best_chr == null)
            return;
        
        showBest = !showBest;
        
        showLines();
    }//GEN-LAST:event_jButton5ActionPerformed
    
    double best_fit = Double.MAX_VALUE;
    String best_str = "";
    Chromosome best_chr = null;
    private void showLines(){
        if(canRun){
            Graphics g =  jPanel6.getGraphics();
            showNodes();
            if(showBest){
                showLinesBest();
                return;
            }
            Chromosome parent = tsp.getParent();
            
            for(int i = 1; i < parent.chrom.size(); i++){
                int a = parent.chrom.get(i-1);
                int b = parent.chrom.get(i);
                g.drawLine(tsp.nodes[a].x, tsp.nodes[a].y, tsp.nodes[b].x, tsp.nodes[b].y);
            }
            int a = parent.chrom.get(0);
            int b = parent.chrom.get(parent.chrom.size() - 1);
            g.drawLine(tsp.nodes[a].x, tsp.nodes[a].y, tsp.nodes[b].x, tsp.nodes[b].y);
            
            
            // Create chromsome string
            String str = "";
            for(int idx : parent.chrom) // Get indexes
                str = str + Integer.toString(idx) + " ";
            str = str.substring(0, str.length()-1); // Remove last char
            
            if (parent.fitness < best_fit){
                best_fit = parent.fitness;
                best_str = str;
                best_chr = parent;
            }
            
            jLabel2.setText("<html><table><tr><td>Fitness: " 
                    + (int) parent.fitness +" km</td><td>Nodes: "
                    + str + "</td></tr>"
                    + "<tr><td>Best fitness: " 
                    + (int) best_fit +" km</td><td>Nodes:"+best_str+"</td></tr></table></html>");
            
        }
        
    }
    boolean showBest = false;
    private void showLinesBest(){
        if(canRun){
            Graphics g =  jPanel6.getGraphics();
            g.setColor(Color.orange);
            Chromosome parent = best_chr;
            for(int i = 1; i < parent.chrom.size(); i++){
                int a = parent.chrom.get(i-1);
                int b = parent.chrom.get(i);
                g.drawLine(tsp.nodes[a].x, tsp.nodes[a].y, tsp.nodes[b].x, tsp.nodes[b].y);
            }
            int a = parent.chrom.get(0);
            int b = parent.chrom.get(parent.chrom.size() - 1);
            g.drawLine(tsp.nodes[a].x, tsp.nodes[a].y, tsp.nodes[b].x, tsp.nodes[b].y);
            
            
            // Create chromsome string
            String str = "";
            for(int idx : parent.chrom) // Get indexes
                str = str + Integer.toString(idx) + " ";
            str = str.substring(0, str.length()-1); // Remove last char
            
            if (parent.fitness < best_fit){
                best_fit = parent.fitness;
                best_str = str;
                best_chr = parent;
            }
            
            jLabel2.setText("<html><table><tr><td>Fitness: " 
                    + (int) parent.fitness +" km</td><td>Nodes: "
                    + str + "</td></tr>"
                    + "<tr><td>Best fitness: " 
                    + (int) best_fit +" km</td><td>Nodes:"+best_str+"</td></tr></table></html>");
        }
    }
    private void setTSP(){
        tsp.pointsOfXover = Integer.valueOf(fPointsOfXover.getText());
        tsp.crossoverProbabilty = Double.valueOf(fCrossoverProbability.getText());
        tsp.mutationProbabilty = Double.valueOf(fMutationProbability.getText());
        tsp.popSize = Integer.valueOf(fPopSize.getText());
        tsp.strategy = (fStrategy.getSelectedIndex() == 0) ? false : true;
        tsp.offspringsSize = Integer.valueOf(fOffspringsCnt.getText());
        tsp.maxGenerations = Integer.valueOf(fGenerations.getText());
        
        switch (fSelectionPop.getSelectedItem().toString()) {
            case "Turnaj":
                tsp.selectionNewPop = new Tournament();
                break;
            case "Ruleta":
                tsp.selectionNewPop = new Roulette();
                break;
            case "Deterministicky":
                tsp.selectionNewPop = new Deterministic();
                break;
            default:
                tsp.selectionNewPop = new Nahoda();
                break;
        }
        
        switch (fSelectionParent.getSelectedItem().toString()) {
            case "Turnaj":
                tsp.selectionParents = new Tournament();
                break;
            case "Ruleta":
                tsp.selectionParents = new Roulette();
                break;
            default:
                tsp.selectionParents = new Nahoda();
                break;
        }
        popsize = tsp.popSize;
    }

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(SfcGA.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(SfcGA.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(SfcGA.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(SfcGA.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                //System.err.println(info.getName());
                if ("Windows".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(SfcGA.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(SfcGA.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(SfcGA.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(SfcGA.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new SfcGA().setVisible(true);
            }
        });
    }
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JTextField fCrossoverProbability;
    private javax.swing.JTextField fGenerations;
    private javax.swing.JTextField fMutationProbability;
    private javax.swing.JTextField fOffspringsCnt;
    private javax.swing.JTextField fPointsOfXover;
    private javax.swing.JTextField fPopSize;
    private javax.swing.JComboBox fSelectionParent;
    private javax.swing.JComboBox fSelectionPop;
    private javax.swing.JComboBox fStrategy;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButton3;
    private javax.swing.JButton jButton4;
    private javax.swing.JButton jButton5;
    private javax.swing.JButton jButton6;
    private javax.swing.JButton jButton7;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel17;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JPanel jPanel6;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JTabbedPane jTabbedPane1;
    private javax.swing.JTextArea textOutput;
    // End of variables declaration//GEN-END:variables
}


interface SendMsg {
    void print();
    void print(String a);
}